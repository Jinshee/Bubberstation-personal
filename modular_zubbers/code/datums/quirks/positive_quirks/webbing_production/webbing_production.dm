/datum/quirk/spider_aspect
	name = "Spider Aspect"
	desc = "Certain humanoid insectoids strongly resemble arachnids in their ability for the fine manipulation of silk. (Do not use this quirk if you are not an insectoid)"
	value = 6
	mob_trait = TRAIT_SPIDER_ASPECT
	gain_text = span_notice("You could easily spin a web.")
	lose_text = span_danger("Somehow, you've lost your ability to weave.")
	medical_record_text = "Patient has the ability to weave webs with naturally synthesized silk."
	icon = FA_ICON_STICKY_NOTE

/datum/quirk/spider_aspect/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/action/cooldown/mob_cooldown/webbing/action = new /datum/action/cooldown/mob_cooldown/webbing
	action.Grant(human_holder)

/datum/quirk/spider_aspect/remove()
	if(QDELETED(quirk_holder))
		return ..()
	var/datum/action/cooldown/mob_cooldown/webbing/action = locate(/datum/action/cooldown/mob_cooldown/webbing) in quirk_holder.actions
	action.Remove()

	return ..()

//owner.add_traits(list(TRAIT_WEB_WEAVER, TRAIT_WEB_SURFER), GENETIC_MUTATION)
//owner.remove_traits(list(TRAIT_WEB_WEAVER, TRAIT_WEB_SURFER), GENETIC_MUTATION)

/datum/action/cooldown/mob_cooldown/webbing
	name = "Spin Web"
	desc = "Choose a silk structure to begin weaving."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "spider_web"
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_INCAPACITATED | AB_CHECK_HANDS_BLOCKED // cant use it if cuffed
	/// Turfs that you cannot weave on
	var/static/list/blacklisted_turfs = typecacheof(list(/turf/open/space, /turf/open/openspace, /turf/open/lava))
	/// Whether we're currently weaving a web
	var/weaving = FALSE
	/// How long it takes to lay a web
	var/webbing_time = 4 SECONDS

/datum/action/cooldown/mob_cooldown/lay_web/proc/obstructed_by_other_web()
	return !!(locate(/obj/structure/spider/stickyweb) in get_turf(owner))

/datum/action/cooldown/mob_cooldown/webbing/Activate()
	. = ..()
	var/turf/spider_turf = get_turf(owner)
	var/obj/structure/spider/stickyweb/web = locate() in spider_turf
	if(web)
		return FALSE
	else
		owner.visible_message(span_warning("[owner] prepares [owner.p_their()] spinneret..."), span_notice("You prepare your spinneret..."))
	try_weave(spider_turf, web)

/datum/action/cooldown/mob_cooldown/webbing/proc/try_weave(turf/open/target_turf, mob/user)
	var/turf/open/current_turf = get_turf(owner)
	if(weaving)
		target_turf.balloon_alert(user, "already weaving!")
		return
	if(current_turf && istype(blacklisted_turfs))
		target_turf.balloon_alert(user, "nothing to stick to!")
		return NONE

	weaving = TRUE
	weave(target_turf, user)
	weaving = FALSE

/datum/action/cooldown/mob_cooldown/webbing/proc/weave(turf/open/target_turf, mob/user)
	// Assoc list of [name] to [image] for the radial (to show tooltips)
	var/static/list/choices = list()
	// Assoc list of [name] to [path] for after the radial
	var/static/list/names_to_path = list()
	if(!choices.len || !names_to_path.len)
		for(var/obj/structure/spider/stickyweb/quirky as anything in subtypesof(/obj/structure/spider/stickyweb))
			names_to_path[initial(quirky.name)] = quirky
			choices[initial(quirky.name)] = image(icon = initial(quirky.icon), icon_state = initial(quirky.icon_state))

	var/picked_choice = show_radial_menu(
		user,
		target_turf,
		choices,
		require_near = TRUE,
		tooltips = TRUE,
		)

	if(isnull(picked_choice))
		return

	var/to_make = names_to_path[picked_choice]
	if(!ispath(to_make, /obj/structure/spider/stickyweb))
		CRASH("[type] attempted to create a web of incorrect type! (got: [to_make])")

	target_turf.balloon_alert(user, "weaving [picked_choice]...")
	user.playsound_local(target_turf, 'sound/items/sheath.ogg', 50, TRUE)
	if(!do_after(user, 5 SECONDS, target = target_turf))
		target_turf.balloon_alert(user, "interrupted!")
		return

	target_turf.balloon_alert(user, "[picked_choice] woven")
	//var/obj/structure/spider_quirk/new_web = new to_make(target_turf, user)
