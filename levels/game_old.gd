extends Control
class_name game_old
var board_data: Array[main.types] = []
const winning_lines = [
	[0,1,2], [3,4,5], [6,7,8], # horizontal
	[0,3,6], [1,4,7], [2,5,8], # vertical
	[0,4,8], [2,4,6]           # diagonal
]
var board_cells: Array[Cell]
var gameended: bool = false
var current_turn: main.types = main.types.CROSS

signal gameend(whowon: main.WINTYPES)

func _ready() -> void:
	board_data.resize(9)
	board_data.fill(main.types.NULL)
	for i: Cell in $GridContainer.get_children():
		i.connect("clicked", _on_cell_clicked)
		board_cells.append(i)
	if main.AI == main.types.CROSS:
		_ai_turn()

func _on_cell_clicked(cellid: int, playernum: main.types) -> void:
	if gameended:
		return
	if !main.localcoop and current_turn != main.PLAYER and playernum == main.PLAYER:
		return # simplified: IF localcoop is not turned on and its not the player1 turn and the player1 clicked on a cell do nothing.
	if _set_type(cellid, current_turn) == false:
		return
	var winner: int =_check_winning_condition(board_data)
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
		return
	
	if current_turn == main.PLAYER:
		if !main.twoplayers:
			_set_turn(main.AI)
			_ai_turn()
		else:
			_set_turn(main.PLAYER2)
	else:
		_set_turn(main.PLAYER)

func _set_type(cellid: int, newtype: main.types) -> bool:
	var cell: Cell = $GridContainer.get_child(cellid - 1)
	
	if cell.type != main.types.NULL:
		main.print_debug_warn(str(cell.name, " type is already not null, ignoring..."))
		return false
	if newtype == main.types.NULL:
		printerr("Null cannot be set as a type.") # safety stuff.
		return false
		
	cell.get_node("TextureRect").self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	board_data.set(cellid - 1, newtype)
	
	if newtype == main.types.CROSS:
		cell.get_node("TextureRect").texture = cell.Cross
		cell.type = newtype

	elif newtype == main.types.CIRCLE:
		cell.get_node("TextureRect").texture = cell.Circle #probably could use a signal or a function instead
		cell.type = newtype                                #but this works too.

	return true


func _set_turn(type: main.types) -> void:
	if !main.localcoop:
		if type != main.PLAYER:
			for i: Cell in board_cells:
				i.current_turn = main.types.NULL 
		else:
			for i: Cell in board_cells: #If its not a players turn and localcoop is disabled, tell all cells
				i.current_turn = type   #to not display anything on hover. (shitty way but it works™)   
	else:
		for i: Cell in board_cells:
			i.current_turn = type
	current_turn = type

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
		board_copy.set(i, main.AI)
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
		_on_cell_clicked(random_move + 1, main.AI)
	else:
		printerr("AI Has not found any moves. This should NOT be possible.")

func minimax(is_maxing: bool, board_copy: Array, depth: int, alpha: int, beta: int) -> int:
	var winner: int = _check_winning_condition(board_copy)
	
	if winner != main.WINTYPES.NULL:
		if winner == main.WINTYPES.DRAW:
			return 0 # DRAW
		if winner == main.AI:
			return 10 - depth
		else:
			return -10 + depth

	var available_moves: Array
	for i in board_copy.size(): # find all possible moves
		if board_copy[i] == 0:
			available_moves.append(i)
	if main.beatable_ai == true and randi() % 10 == 1: # AI Crack™ to make it be able to lose.
		return(randi_range(-10, 10))
	if is_maxing == true:
		for i in available_moves: # do every possible move in a board copy
			board_copy.set(i, main.AI)
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
