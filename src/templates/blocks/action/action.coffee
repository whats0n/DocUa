$("#select-specialization").on "click", "li a", ->
  item = $(this)	


  # $('.direction__btn').empty()
  $('.js-clone span').text(item.text()) 
  $('.js-clear' ).addClass 'is-active'
  $('.direction__title').text('Выбрано направление')  
  return $("#select-specialization").modal "hide" 
  
$(".js-clear").on "click", ->
  $(this).siblings("span").text("Выберите направление")
  $(this).removeClass 'is-active'
  $('.direction__title').text('Направление') 
  return false
 