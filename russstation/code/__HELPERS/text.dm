/proc/typing_input(mob/user, message = "", title = "", default = "") //Proc to enter a certain state after an input is called, needed for the indicator
	if(user.client.checkTyping()) // Prevent multiple windows
		return null

	user.client.typing = TRUE
	var/msg = input(user, message, title, default) as text|null
	user.client.typing = FALSE
	return msg
