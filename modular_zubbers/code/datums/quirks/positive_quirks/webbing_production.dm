/datum/quirk/webbing_aspect
	name = "Spider Aspect"
	desc = "Certain humanoid insectoids strongly resemble arachnids in their ability for the fine manipulation of silk. (Do not use this quirk if you are not an insectoid)"
	value = 6
	mob_trait = TRAIT_WEBBING_ASPECT
	gain_text = span_notice("You could easily spin a web.")
	lose_text = span_danger("Somehow, you've lost your ability to weave.")
	medical_record_text = "Patient has the ability to weave webs with naturally synthesized silk."
	icon = FA_ICON_STICKY_NOTE

/datum/quirk/webbing_aspect/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/action/cooldown/mob_cooldown/webbing/action = new /datum/action/cooldown/mob_cooldown/webbing
	action.Grant(human_holder)

/datum/quirk/webbing_aspect/remove()
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

/datum/action/cooldown/mob_cooldown/webbing/set_click_ability(mob/on_who)
	. = ..()
	owner.visible_message(span_warning("[owner] prepares [owner.p_their()] spinneret..."), span_notice("You prepare your spinneret..."))
