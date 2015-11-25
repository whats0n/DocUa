$.fn.initFavoritesBlock = ->
    @each ->
        {favored, favoritesBlockInitialized} = $(@).data()
        return if favoritesBlockInitialized
        $(@).toggleClass "favorites-block_favored", !!favored
        $(@).data "favoritesBlockInitialized", yes

        $(@).on 'click', (e) ->
            {favored} = $(@).data()
            favored = !favored
            $(@).toggleClass "favorites-block_favored", !!favored
            $(@).data 'favored', !!favored
            $(@).trigger if !!favored then 'favored' else 'unfavored'
            e.preventDefault()

$(".favorites-block").initFavoritesBlock()
