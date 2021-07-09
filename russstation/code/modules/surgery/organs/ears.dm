/obj/item/organ/ears/skaven
	name = "skaven ears"
	icon = 'russstation/icons/obj/clothing/hats.dmi'
	icon_state = "skaven"

/obj/item/organ/ears/skaven/Insert(mob/living/carbon/human/ear_owner, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(ear_owner))
		color = "#[ear_owner.dna.features["skavencolor"]]"
		ear_owner.dna.features["ears"] = ear_owner.dna.species.mutant_bodyparts["ears"] = "Skaven"
		ear_owner.update_body()

/obj/item/organ/ears/skaven/Remove(mob/living/carbon/human/ear_owner,  special = 0)
	..()
	if(istype(ear_owner))
		color = ear_owner.hair_color
		ear_owner.dna.features["ears"] = "None"
		ear_owner.dna.species.mutant_bodyparts -= "ears"
		ear_owner.update_body()
