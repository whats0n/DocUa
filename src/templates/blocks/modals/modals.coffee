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


$("#select-area-diagnostics").on "click", "li a", ->
  return $("#select-area-diagnostics").modal "hide"
  