# autocomplete

$(".js-autocomplete-doc").each ->
	availableTags = [
	    'Аллерголог'
	    'Андролог'
	    'Анестезиолог'
	    'Венеролог'
	    'Вертебролог'
	    'Гастроэнтеролог'
	    'Гематолог'
	    'Генетик'
	    'Дерматолог'
	    'Диетолог'
	    'Иммунолог'
	    'Кардиолог'
	    'Кинезитерапевт'
	    'Логопед'
	    'Маммолог'
	    'Нарколог'
	    'Невролог'
	    'Ортопед'
	    'Педиатр'
	    'Подолог'
	    'Ревматолог'
	    'Терапевт'
	]
	$('.js-autocomplete-doc').autocomplete 
		source: availableTags

$(".js-autocomplete-clinic").each ->
	availableTags = [
	    'Инсайт Медикал'
	    'Саперная слободка'
	    'Исида'
	    'Феврония Клинская'
	    'Валерия Ильинишна Колмагорова'
	    'Феврония Клинская'
	    'Добробут'
	]
	$('.js-autocomplete-clinic').autocomplete 
		source: availableTags
