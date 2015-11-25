$(document).on "change", ".pill-group .pill input", (e) ->
  $pill = $(e.target).closest(".pill")
  checked = $(e.target).is(":checked")
  $childrenPills = $pill.siblings("ul").find(".pill")
  if $childrenPills.length > 0
    $childrenPills.find("input").prop "checked", checked
  else
    $parentPill = $pill.closest("ul").siblings(".pill")
    if $parentPill.length is 1
      $pillsGroup = $parentPill.siblings("ul").find(".pill")
      allChecked = $pillsGroup.length is $pillsGroup.find(":checked").length
      $parentPill.find("input").prop "checked", allChecked