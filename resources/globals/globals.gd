class_name GlobalVariables extends Node

@export var SPEED: Vector2 = Vector2(-125, 0)

@export var selected_language: String = 'en'
@export var locale: Dictionary[String, Dictionary] = {
	'en':{
		'menu_title': 'Birds Must Be Free!',
		'menu_new_game': 'New Game',
		'menu_exit_game': 'Exit',
		'menu_language': 'Language',
		'game_age': 'Age: {0}',
		'game_money': 'Money: {0}{1}',
		'game_loan': 'Loan: $ {0}',
		'game_over_title': 'Game Over',
		'game_over_quote_normal': 'what a mesmerizing cage it was',
		'game_over_quote_revolution': 'but the struggle lives on',
		'game_over_age_text_normal': 'You worked until you were {0} years old',
		'game_over_age_text_revolution': 'You lived until you were {0} years old',
		'game_over_money_text_normal': 'You accumulated... it doesn\'t matter now, does it?',
		'game_over_money_text_loan': 'Your debt will live on to your loved ones',
		'game_over_cause_text_overwork': 'You died of overwork',
		'game_over_cause_text_old': 'You died of old age, but not retired',
		'game_over_cause_text_revolution': 'You died defending the working class',
		'game_over_button_text_normal': 'Could there be more?',
		'game_over_button_text_revolution': 'You\'ve seen the keys'
		},
	'pt':{
		'menu_title': 'Pássaros Devem Ser Livres!',
		'menu_new_game': 'Novo Jogo',
		'menu_exit_game': 'Sair',
		'menu_language': 'Linguagem',
		'game_age': 'Idade: {0}',
		'game_money': 'Dinheiro: {0}{1}',
		'game_loan': 'Empréstimo: $ {0}',
		'game_over_title': 'Fim do jogo', 
		'game_over_quote_normal': 'mas que gaiola hipnotizante', 
		'game_over_quote_revolution': 'mas a luta continua', 
		'game_over_age_text_normal': 'Você trabalhou até os {0} anos de idade', 
		'game_over_age_text_revolution': 'Você viveu até os {0} anos de idade', 
		'game_over_money_text_normal': 'Você acumulou... isso não importa mais, não é?', 
		'game_over_money_text_loan': 'Sua dívida permanecerá com seus entes queridos', 
		'game_over_cause_text_overwork': 'Você morreu de excesso de trabalho', 
		'game_over_cause_text_old': 'Você morreu de velhice, sem aposentadoria', 
		'game_over_cause_text_revolution': 'Você morreu defendendo a classe trabalhadora', 
		'game_over_button_text_normal': 'Pode haver mais?', 
		'game_over_button_text_revolution': 'Você viu as chaves'
	}
}
