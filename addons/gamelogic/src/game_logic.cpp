#include "game_logic.h"

GameLogic *GameLogic::singleton = nullptr;

void GameLogic::enter_crash_zone() {
	// Executing the following code crashes the game
	print_line("Entering crash zone...");
	char *chr = (char *)1;
	print_line(chr);
}

int GameLogic::divide(int a, int b) {
	// Division by 0 should result in crash
	int rv = a / b;
	print_line("Division result: ", rv);
	return rv;
}

void GameLogic::_bind_methods() {
	ClassDB::bind_method(D_METHOD("enter_crash_zone"), &GameLogic::enter_crash_zone);
	ClassDB::bind_method(D_METHOD("divide", "a", "b"), &GameLogic::divide);
}
