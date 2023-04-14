// Admin panel for viewing the Cryptocurrency app
// yoinked from newscaster admin button
/datum/admins/proc/manage_cryptocurrency()
	set category = "Admin.Events"
	set name = "Manage Cryptocurrency"
	set desc = "Allows you to view and manage the active cryptocurrency."

	if (!istype(src, /datum/admins))
		src = usr.client.holder
	if (!istype(src, /datum/admins))
		to_chat(usr, "Error: you are not an admin!", confidential = TRUE)
		return

	var/datum/cryptopanel/new_cryptopanel = new

	new_cryptopanel.ui_interact(usr)

/datum/cryptopanel

/datum/cryptopanel/ui_state(mob/user)
	return GLOB.admin_state

/datum/cryptopanel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Cryptocurrency")
		ui.open()

// yoinked from crypto module program
/datum/cryptopanel/ui_data()
	var/list/data = list()

	data["authenticated"] = TRUE //adminbuse
	data["coin_name"] = SScryptocurrency.coin_name
	data["exchange_rate"] = SScryptocurrency.exchange_rate
	data["wallet"] = SScryptocurrency.wallet
	data["progress_required"] = SScryptocurrency.progress_required
	data["exchange_rate_limit"] = initial(SScryptocurrency.exchange_rate) * 2
	data["total_mined"] = SScryptocurrency.total_mined
	data["total_payout"] = SScryptocurrency.total_payout
	data["mining_history"] = SScryptocurrency.mining_history
	data["payout_history"] = SScryptocurrency.payout_history
	data["exchange_rate_history"] = SScryptocurrency.exchange_rate_history
	data["market_closed"] = !SScryptocurrency.can_fire
	var/list/rigs = list()
	for(var/obj/machinery/crypto_mining_rig/rig in SScryptocurrency.machines)
		var/rig_data = list()
		rig_data["name"] = rig.name
		rig_data["on"] = rig.on
		rig_data["progress"] = rig.progress
		rigs += list(rig_data)
	data["machines"] = rigs

	return data

/datum/cryptopanel/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("PRG_exchange")
			var/mob/user = usr
			var/message = SScryptocurrency.cash_out(user)
			if(message)
				minor_announce(message, "[SScryptocurrency.coin_name] Exchange Market")
		// todo more buttons to manipulate stuff?
