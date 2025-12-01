extends Control
class_name game

const winning_lines = [
	[0,1,2], [3,4,5], [6,7,8], # horizontal
	[0,3,6], [1,4,7], [2,5,8], # vertical
	[0,4,8], [2,4,6]           # diagonal
]
var board_cells: Array[Cell]
var board_data: Array[main.types] = []
var gameended: bool = false
signal gameend(winner: main.WINTYPES)

var current_turn: main.types = main.PLAYER

func _ready() -> void:
	board_data.resize(9)
	board_data.fill(main.types.NULL)
	for i: Cell in $GridContainer.get_children():
		i.connect("clicked", _on_cell_clicked)
		board_cells.append(i)


func _on_cell_clicked(cellid: int) -> void:
	if gameended:
		return
	match main.gamemode:
		main.gamemodes.AI:
			if make_move(cellid, current_turn) == false:
				return
			current_turn = main.PLAYER2
			_ai_turn()
		main.gamemodes.MULTIPLAYER:
			pass # TODO
		main.gamemodes.LOCALMULTIPLAYER:
			if make_move(cellid, current_turn) == false:
				return
			if current_turn == main.PLAYER:
				_set_current_turn(main.PLAYER2)
			else:
				_set_current_turn(main.PLAYER)

func _set_current_turn(turn: main.types) -> void:
		current_turn = turn
		for i in board_cells:
			i.current_turn = turn


func make_move(cellid: int, type: main.types) -> bool:
	if gameended:
		return false
	var cell: Cell = board_cells[cellid - 1]
	if cell.type != main.types.NULL:
		main.print_warn(str(cell.name, " type is already not null, ignoring..."))
		return false
	if type == main.types.NULL:
		printerr("Null cannot be set as a type.") # safety stuff.
		return false
	board_data.set(cellid - 1, type)
	cell.set_move(type)
	_post_move()
	return true

func _check_winning_condition(board: Array) -> main.WINTYPES:
	for line in winning_lines:
		var a = board[line[0]]
		var b = board[line[1]]
		var c = board[line[2]]
		if a != main.types.NULL and a == b and b == c:
			return a # winner
	if not board.has(main.types.NULL):
		return main.WINTYPES.DRAW # draw
	return main.WINTYPES.NULL # nothing ever happens

func _post_move() -> void:
	var winner = _check_winning_condition(board_data)
	if winner != main.WINTYPES.NULL:
		if winner == main.WINTYPES.DRAW:
			gameend.emit(main.WINTYPES.DRAW)
			print_debug("draw")
		elif winner == main.WINTYPES.CIRCLE:
			gameend.emit(main.WINTYPES.CIRCLE)
			print_debug("circle")
		elif winner == main.WINTYPES.CROSS:
			gameend.emit(main.WINTYPES.CROSS)
			print_debug("cross")
		gameended = true

func _ai_turn() -> void:
	var board_copy = board_data.duplicate()
	var best_score: int = -1000
	var best_moves: Array
	var possible_moves: Array
	const ALPHA: int = -1000
	const BETA: int = 1000
	
	for i in board_copy.size(): # find all possible moves
		if board_copy[i] == 0:
			possible_moves.append(i)
	
	for i in possible_moves:
		board_copy.set(i, main.PLAYER2)
		var score = minimax(false, board_copy, 0, ALPHA, BETA)
		board_copy.set(i, main.types.NULL)
		if score > best_score:
			best_score = score
			best_moves = [i]
		elif score == best_score:
			best_moves.append(i)
	print_debug(best_moves.size())
	if best_moves.size() > 0:
		var random_move = best_moves.pick_random()
		make_move(random_move + 1, main.PLAYER2)
		current_turn = main.PLAYER
	else:
		main.print_warn("AI Has not found any moves. This should NOT be possible.")

func minimax(is_maxing: bool, board_copy: Array, depth: int, alpha: int, beta: int) -> int:
	var winner: int = _check_winning_condition(board_copy)
	
	if winner != main.WINTYPES.NULL:
		if winner == main.WINTYPES.DRAW:
			return 0 # DRAW
		if winner == main.PLAYER2:
			return 10 - depth
		else:
			return -10 + depth

	var available_moves: Array
	for i in board_copy.size(): # find all possible moves
		if board_copy[i] == 0:
			available_moves.append(i)
	if main.beatableai == true and randi() % 10 == 1: # AI Crack™ to make it be able to lose.
		return(randi_range(-10, 10))
	if is_maxing == true:
		for i in available_moves: # do every possible move in a board copy
			board_copy.set(i, main.PLAYER2)
			var eval = minimax(!is_maxing, board_copy, depth + 1, alpha, beta)
			board_copy.set(i, main.types.NULL)
			alpha = max(eval, alpha)
			if beta <= alpha: # alpha beta shit optimization ig idk
				break
		return(alpha)
	else:
		for i in available_moves: # do every possible move in a board copy
			board_copy.set(i, main.PLAYER)
			var eval = minimax(!is_maxing, board_copy, depth + 1, alpha, beta)
			board_copy.set(i, main.types.NULL)
			beta = min(eval, beta)
			if beta <= alpha: # alpha beta shit optimization ig idk
				break
		return(beta)
