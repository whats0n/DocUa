$ ->
    updateGroup1 = ->
        $(".x-check-group1").toggle $(".x-check-group1-toggle").prop "checked"

    updateGroup1()
    $(".x-check-group1-toggle").change updateGroup1

    updateGroup2 = ->
        $(".x-check-group2").toggle $(".x-check-group2-toggle").prop "checked"

    updateGroup2() 
    $(".x-check-group2-toggle").change updateGroup2

   

$('.bs-modal-md').on 'show.bs.modal', (e) ->
  setTimeout ->
    $('.js-list-scroll').jScrollPane({
    	autoReinitialise: true
    })
    return
  , 10
  return

myFunctionResize = ->
    pane = $('.js-list-scroll')
    pane.jScrollPane();
    api = pane.data('jsp');
    api.reinitialise();
    return
    
$(".dropdown__btn").on "click", ->
  if $(window).width() < 560
    setTimeout ->
      myFunctionResize()
      return
    , 15 
    return

$(window).resize ->
  myFunctionResize()
  return
  




$("#select-area-diagnostics").on "click", "li a", ->
  return $("#select-area-diagnostics").modal "hide"
   
# validate date
# isValidDate2 = (str) ->
#   input = str.match(/\d+/g)
#   date = new Date(input[2], input[1] - 1, input[0]) 
#   date.getFullYear() == +input[2] && date.getMonth() == +input[1] - 1 && date.getDate() == +input[0]

# $('select').change -> 
#   date = $('.js-valDate').find('select').val()
#   month = $('.js-valMonth').find('select').val()
#   years = $('.js-valYears').find('select').val() 
#   all = date + '/' + month + '/' + years 

#   if isValidDate2(all) 
#     $(this).closest('.form-group').removeClass('has-error')
#   else
#     $(this).closest('.form-group').addClass('has-error')
#   return 