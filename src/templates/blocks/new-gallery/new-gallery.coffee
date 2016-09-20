galleryOption = {
	thumbnail: true,
	animateThumb: false,
	showThumbByDefault: true,
	currentPagerPosition: 'left',
	thumbWidth: 40,
	thumbContHeight: 100, 
	toogleThumb: false,
	exThumbImage: 'data-exthumbimage',
	width: '825px',
	height: '600px',
	mode: 'lg-fade',
	download: false,
	enableSwipe: false,
	enableDrag: false,
	ubHtmlSelectorRelative: true
}

sliderOption = {

}

lightGallery document.getElementById('js-lightgallery'), 
	galleryOption

lightGallery document.getElementById('js-lightgallery2'), 
	galleryOption

lightGallery document.getElementById('js-lightgallery3'), 
	galleryOption


gallerySlider = $(".js-light-slider").lightSlider
	slideMargin: 0,
	loop: false,
	item: 4,
	autoWidth: false,
	controls: true,
	pager: false,
	adaptiveHeight:true,
	responsive : [
		{
			breakpoint: 1200,
			settings: {
				item: 3,
				slideMove: 1,
				slideMargin: 0,
			}
		},
		{
			breakpoint: 700,
			settings: {
				item:2,
				slideMove:1
			}
		},
		{
			breakpoint: 440,
			settings: {
				item: 1,
				slideMove:1
			}
		}
	]
gallerySlider2 = $(".js-light-slider2").lightSlider
	slideMargin: 0,
	loop: false,
	item: 4,
	autoWidth: false, 
	controls: true,
	pager: false,
	adaptiveHeight:true,
	responsive : [
		{
			breakpoint: 1200,
			settings: {
				item: 3,
				slideMove: 1,
				slideMargin: 0,
			}
		},
		{
			breakpoint: 700,
			settings: {
				item:2,
				slideMove:1
			}
		},
		{
			breakpoint: 440,
			settings: {
				item: 1,
				slideMove:1
			}
		}
	]
gallerySlider3 = $(".js-light-slider3").lightSlider
	slideMargin: 0,
	loop: false,
	item: 4,
	autoWidth: false,
	controls: true,
	pager: false,
	adaptiveHeight:true,
	responsive : [
		{
			breakpoint: 1200,
			settings: {
				item: 3,
				slideMove: 1,
				slideMargin: 0,
			}
		},
		{
			breakpoint: 700,
			settings: {
				item:2,
				slideMove:1
			}
		},
		{
			breakpoint: 440,
			settings: {
				item: 1,
				slideMove:1
			}
		}
	]

$('body').on 'click', '.js-slider-refresh', ->
	console.log('bla')
	gallerySlider.refresh()
	gallerySlider2.refresh()
	gallerySlider3.refresh() 
