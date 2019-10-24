/mob/living/simple_animal/bot/secbot/bearsky
    name = "Officer Bearsky"
    desc = "Has the right to bear arms."
    auto_patrol = TRUE
    icon =  'russstation/icons/mob/aibots.dmi'
    icon_state = "bearsky"
    health = 60 // he's a beefy boy
    maxHealth = 60

    idcheck = TRUE
    weaponscheck = TRUE

/mob/living/simple_animal/bot/secbot/bearsky/stun_attack(mob/living/carbon/C)
    var/judgement_criteria = judgement_criteria()
    playsound(src, 'sound/weapons/cqchit2.ogg', 50, TRUE, -1)
    addtimer(CALLBACK(src, /atom/.proc/update_icon), 2)
    var/threat = 5
    C.Paralyze(100)
    threat = C.assess_threat(judgement_criteria, weaponcheck=CALLBACK(src, .proc/check_for_weapons))

    log_combat(src,C,"tackled")
    if(declare_arrests)
        var/area/location = get_area(src)
        speak("[arrest_type ? "Hunting" : "Mauling"] level [threat] scumbag <b>[C]</b> in [location].", radio_channel)
    C.visible_message("<span class='danger'>[src] has tackled [C]!</span>",\
                            "<span class='userdanger'>[src] has tackled you!</span>")

/mob/living/simple_animal/bot/secbot/bearsky/look_for_perp()
    anchored = FALSE
    var/judgement_criteria = judgement_criteria()
    for (var/mob/living/carbon/C in view(7,src)) //Let's find us a criminal
        if((C.stat) || (C.handcuffed))
            continue

        if((C.name == oldtarget_name) && (world.time < last_found + 100))
            continue

        threatlevel = C.assess_threat(judgement_criteria, weaponcheck=CALLBACK(src, .proc/check_for_weapons))

        if(!threatlevel)
            continue

        else if(threatlevel >= 4)
            target = C
            oldtarget_name = C.name
            playsound(loc, 'russstation/sound/effects/bearhuuu.ogg', 75, FALSE)
            visible_message("<b>[src]</b> growls at [C.name]!")
            mode = BOT_HUNT
            INVOKE_ASYNC(src, .proc/handle_automated_action)
            break
        else
            continue

/mob/living/simple_animal/bot/secbot/bearsky/explode()
    walk_to(src,0)
    visible_message("<span class='boldannounce'>[src] blows apart!</span>")

    var/atom/location = drop_location()
    new /obj/item/clothing/head/bearpelt(location)
    new /obj/effect/decal/cleanable/oil(location)

    do_sparks(8, TRUE, src) // lots of sparks
    qdel(src)

/mob/living/simple_animal/bot/secbot/emag_act(mob/user)
    ..()
    if(emagged == 2)
        if(user)
            to_chat(user, "<span class='danger'>You enrage [src]</span>")
            oldtarget_name = user.name
        audible_message("<span class='danger'>[src] growls angrily!</span>")
        declare_arrests = FALSE
        update_icon()
