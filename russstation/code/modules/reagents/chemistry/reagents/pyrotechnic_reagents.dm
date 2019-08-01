/datum/reagent/raney_nickel
	name = "Raney Nickel"
	description = "A fine grey powder known for being lightly pyrophoric."
	reagent_state = SOLID
	color = "#7d7d7d" // RGB: 125, 125, 125
	taste_description = "metal"

/datum/reagent/raney_nickel/reaction_turf(turf/T, volume)
	if(volume < 5) return // no easy hotspots for a pyronade

	if(isfloorturf(T))
		var/turf/open/floor/F = T
		F.burn_tile()

	if(!isspaceturf(T))
		new /obj/effect/hotspot(T)
