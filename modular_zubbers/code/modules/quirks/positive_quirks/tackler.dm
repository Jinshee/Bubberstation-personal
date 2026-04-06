/datum/quirk/tackler
	name = "Tackler"
	desc = "You've spent years throwing yourself head-first into walls. You might be a little slow, but your football coach didn't mind."
	medical_record_text = "Patient seems capable of explosive bursts of adrenaline."
	value = 8
	icon = FA_ICON_HAND_FIST
	var/datum/component/tackler/tackle_comp

/datum/quirk/tackler/add(client/client_source)
	tackle_comp = quirk_holder.AddComponent(/datum/component/tackler, \
		stamina_cost = 30, \
		base_knockdown = 1 SECONDS, \
		range = 5, \
		speed = 1.5, \
		skill_mod = 2, \
		min_distance = 0, \
	)

/datum/quirk/tackler/remove()
	QDEL_NULL(tackle_comp)
