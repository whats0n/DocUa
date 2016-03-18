(function($, document, undefined){
	$(function(){
		"use strict";

		function transitionEndEventName() {
			var i,
				undefined,
				el = document.createElement('div'),
				transitions = {
					'transition':'transitionend',
					'OTransition':'otransitionend',  // oTransitionEnd in very old Opera
					'MozTransition':'transitionend',
					'WebkitTransition':'webkitTransitionEnd'
				};

			for (i in transitions) {
				if (transitions.hasOwnProperty(i) && el.style[i] !== undefined) {
					return transitions[i];
				}
			}

		}
		// Calendar setup
		var calendarInput = $('#modal-calendar').pickadate(),
			picker = calendarInput.pickadate('picker'),
			transitionEndEvent = transitionEndEventName();

		picker.set('min', new Date());
		picker.on('set', function(set) {
			console.log(set);
		});

		$('.picker__weekday').removeAttr('title');


		// Time selected
		var timeSelect = $('.modal-time');

		$('input[type=checkbox][data-group-id]', timeSelect).on('change', function(e, callObj) {
			var self = $(this),
				cell = self.closest('.modal-time-cell'),
				nextCell = cell.next(),
				prevCell = cell.prev(),
				rowSize = window.innerWidth <= 320 ? 3 : 4,
				maxRows = Math.ceil( $('.modal-time-cell', cell.parent()).size() / rowSize ),
				curCellIndex = cell.index(),
				topCell, bottomCell, selectRow = Math.ceil(curCellIndex / rowSize );

				topCell = curCellIndex+1 <= rowSize ? undefined : $( '.modal-time-cell:nth('+ ( (curCellIndex - (selectRow-1)*rowSize)+(selectRow-2)*rowSize ) +')' ),
				bottomCell = selectRow < maxRows ? $( '.modal-time-cell:nth('+ ( (curCellIndex - (selectRow-1)*rowSize)+ selectRow*rowSize ) +')' ) : undefined;

			console.log(((curCellIndex - (selectRow-1)*rowSize)+(selectRow-2)*rowSize ), topCell, bottomCell);
			if ( self.is(':checked') ) {
				if ( !!topCell && topCell.hasClass('checked') ) {
					topCell.addClass('has-bottom');
					cell.addClass('has-top')
				}
				if ( !!bottomCell && bottomCell.hasClass('checked') ) {
					bottomCell.addClass('has-top');
					cell.addClass('has-bottom')
				}
				if ( !!nextCell && nextCell.hasClass('checked') ) {
					nextCell.addClass('has-left');
					cell.addClass('has-right')
				}
				if ( !!prevCell && prevCell.hasClass('checked') ) {
					prevCell.addClass('has-right');
					cell.addClass('has-left')
				}
				cell.addClass('checked');
			} else {
				if ( !!topCell && topCell.hasClass('checked') ) {
					topCell.removeClass('has-bottom');
					cell.removeClass('has-top')
				}
				if ( !!bottomCell && bottomCell.hasClass('checked') ) {
					bottomCell.removeClass('has-top');
					cell.removeClass('has-bottom')
				}
				if ( !!nextCell && nextCell.hasClass('checked') ) {
					nextCell.removeClass('has-left');
					cell.removeClass('has-right')
				}
				if ( !!prevCell && prevCell.hasClass('checked') ) {
					prevCell.removeClass('has-right');
					cell.removeClass('has-left')
				}
				cell.removeClass('checked');
			}

			if ( !callObj ) {
				clearGroupLabel();
				clearFreeTime();
			} else {
				if ( callObj.attributes['data-group'] ) {
					clearFreeTime();
				}
				if ( /\bfree-time\\b/.test( callObj.className ) ) {
					clearGroupLabel();
				}
			}

		});


		$('a[data-group]', timeSelect).on('click', function(e) {
			e.preventDefault();
			var self = $(this),
				groupId = self.attr('data-group'),
				conteiner = self.closest( '.modal-time' ),
				allGroupLink = $('a[data-group]', conteiner);

			clearSelectTime( this );
			clearFreeTime();
			self.addClass('active');
			$('input[type=checkbox][data-group-id]', conteiner).filter(function() {
				return !this.disabled && groupId == this.attributes['data-group-id'].value;
			}).prop('checked', true).trigger('change', this);
		});

		$('.free-time', timeSelect).on('change', function() {
			clearSelectTime( this );
		});

		function clearSelectTime( callObj ) {
			callObj = callObj || false;
			clearGroupLabel();
			$('input[type=checkbox][data-group-id]', '.modal-time').prop('checked', false).trigger('change', callObj);
		}

		function clearGroupLabel() {
			$('a[data-group]', timeSelect).removeClass('active');
		}

		function clearFreeTime() {
			$('.free-time', '.modal-time').prop('checked', false);
		}

		// Scroll

		var dialogScrollPane = $('.dialog-window-content').jScrollPane().data('jsp').reinitialise(),
			leftContentScrollPane = $('.side-section-content').jScrollPane().data('jsp').reinitialise();


		// Dialog
		var dialogWindow = $('#dialog-window'),
			modalWindow = $('.modal'),
			section;

		$('.list-item', dialogWindow).on('change', function(e) {
			var self = $(this);

			self.closest('.list-item').trigger('change-item', this);
		});

		$('[data-dialog]').on('click', function() {
			var	$thiss = $('.list-item', dialogWindow),
				$this_ = $('.list-item1', dialogWindow);
			dialogWindow.addClass('show-footer');
			recalcScrollPaneHeight( $thiss, dialogScrollPane);
			recalcScrollPaneHeight( $this_, dialogScrollPane);
		});

		$('.modal-left-side').on('remove-item-el', '.list-item', function(e) {
			var self = $(this),
				itemConteiner = self.parent();

			if ( $( '.list-item', itemConteiner).length == 1 ) {
				itemConteiner.remove();
			}
		});

		dialogWindow.on( 'footer-toggle', function(e, show) {
			var self = $(this);
			dialogScrollPane.reinitialise();
		});


		$('.dialog-close').on('click', function() {
			dialogWindow.trigger('close-dialog');
		});


		// $('.js-close-window').on('click', function() {
		// 	dialogWindow.trigger('close-dialog');
		// });

		dialogWindow.on('close-dialog', function() {
			var self = $(this);

			self.removeClass('open');
			$('.side-section-header', '.modal-dialog').removeClass('open-dialog');
		});

		$('[data-dialog]').on('click', function() {

			var self = $(this),
				currentSection = self.closest('.side-section'),
				dialogCenter = Math.floor( dialogWindow.outerHeight()/2 ),
				dialofOffset = dialogWindow.position(),
				dialogHandlerPoint = $('.side-section-header', currentSection).position().top + 5,
				modalHeight = $('.modal-dialog').outerHeight(),
				dialofOffsetTop = 105, lock = false;

			section = undefined;

			// Set dialog position
			if ( dialogHandlerPoint - dialogCenter > 105 ) {
				dialofOffsetTop = dialogHandlerPoint - dialogCenter;
			}
			if ( modalHeight - ( dialogHandlerPoint + dialogCenter ) < 10 ) {
				dialofOffsetTop = modalHeight - 10 - dialogCenter*2;
			}

			var showDialog = function() {
				// dialogWindow.css('top', dialofOffsetTop )
				dialogWindow.addClass('open');

				$('.side-section-header', currentSection).addClass('open-dialog');

				if ($('.js-doctors').hasClass('open')){
					$('.js-doctors').removeClass('open');
					$('.js-doctor-text').removeClass('open-dialog_doctor');
					$('.js-btn-open').removeClass('btn-opacity');
				};

				section = currentSection;

			}

			if ( 'undefined' !== typeof section) {

				dialogWindow.removeClass('open');
				$('.side-section-header', '.modal-dialog').removeClass('open-dialog');
			} else {
				showDialog();
			}

			dialogWindow.on(transitionEndEvent, function(e){
				if ( !lock ) {
					lock = true;
					showDialog();
				}
			});

			return false;
		});

		$('[data-clear-select]', dialogWindow).on('click', function() {
			$( '.remove-item', dialogWindow ).trigger('click');

			return false;
		});

		$('[data-clear-select]', '.js-doctors').on('click', function() {
			$( '.list-item' , '.js-doctors').removeClass('selected');

			return false;
		});

		$('.modal-dialog').on('append-content', '.side-section-content-inner', function(e, content, list_class) {
			content.removeClass('selected');
			list_class = list_class || '';
			if( content.is('li') ) {
				content = $('<ul/>').addClass(list_class).append(content);
			}
			$(this).html(content.wrap('<ul/>'));

		});

		$( '.select-list').on('change', 'input', function() {
			var self = $(this),
				inputId = self.attr('id');

			recalcScrollPaneHeight( $('label[for="'+inputId+'"]') );
		});

		function recalcScrollPaneHeight( el, scrollPane ) {

			var scrollPane = scrollPane || el.closest('.dialog-window-content').data('jsp'),
				footer = $( '.dialog-footer', el.closest('#dialog-window'));

			footer.on(transitionEndEvent, function() {
				scrollPane.reinitialise();
			});
		}


		$(document).on('hide.bs.modal', '.modal', function(e) {
			var self = $(this),
				modal = self.data('bs.modal');


			var close = modal.closeDialog || false;
			if ( close ) {
				modal.closeDialog = undefined;
				return;
			}

			if( 'request-dialog' == $(e.target).attr('id') ) {
				e.preventDefault();
				var closeDialog = $('#close-dialog').clone();
				$( '.modal-dialog', e.target).after( closeDialog );
				closeDialog.css({'opacity': 1});
			}
			
		});

		$(document).on('click', '.button.return', function(e) {
			e.preventDefault();

			$(this).closest('#close-dialog').css('opacity', 0).on(transitionEndEvent, function() {
				$(this).remove();
			});
		}).on('click', '.button.close-dialog', function(e) {
			e.preventDefault();

			var self = $(this),
				modal = self.closest('.modal').data('bs.modal');

			modal['closeDialog'] = true;

			modal.hide();

			modal.$element.on('hidden.bs.modal', function() {
				self.closest('#close-dialog').remove();
			});

		});
		// radio
		$('#radio1').click( function () {
			var $this = $(this),
				$parents = $this.parents('.radio-item');
			$('.this-text1').addClass('is-active_color');
			$('.radio-text_hide1').addClass('is-active');
		});
		$('#radio2').click( function () {
			$('.this-text2').addClass('is-active_color');
			$('.radio-text_hide2').addClass('is-active');
		});
		$('#radio3').click( function () {
			$('.this-text3').addClass('is-active_color');
			$('.radio-text_hide3').addClass('is-active');
		});
		$('#radio4').click( function () {
			$('.this-text4').addClass('is-active_color');
			$('.radio-text_hide4').addClass('is-active');
		});



		// Media
		if (window.matchMedia("screen and (max-width: 640px)").matches) {
		    $('.js-btn-info').addClass("js-btn-info__mobile");
		    $('.js-btn-cal').addClass("js-btn-cal__mobile");
		    $('.js-btn-time').addClass("js-btn-time__mobile");
		}


		//tabs
		$('.js-btn-info__mobile, .tab-close').click( function () {
			$('.js-content-hide').slideToggle('fast');
			$('.tab-close').toggleClass('tab-active_info');
			//event.stopPropagation();
			return false;
		});
		$('.js-btn-cal__mobile, .tab-close__calendar').click( function () {
			$('.modal-calendar').slideToggle('fast');
			$('.tab-close__calendar').toggleClass('tab-active_calendar');
			//event.stopPropagation();
			return false;
		});

		$('.js-btn-time__mobile, .tab-close__time').click( function () {
			$('.modal-time').slideToggle('fast');
			$('.tab-close__time').toggleClass('tab-active_calendar');
			//event.stopPropagation();
			return false;
		});


		//second window
		$('body').on('click', '.js-close-item', function(){
			var $block = $('.js-doctors'),
				data = $(this).data("name"),
				$item = $block.find($('[data-name=\''+ data +'\']')),
				$itemParent = $item.parents('.list-item');
			$(this).remove();
			$itemParent.removeClass('selected');
		});

		// open window-doctors
		$('.js-btn-open').on('click', function (){
			var	$this_ = $('.list-item', '.js-doctors');

			recalcScrollPaneHeight( $this_, dialogScrollPane);
			$('.js-doctors').addClass('show-footer');
			$(this).addClass('btn-opacity');
			$('.js-doctors').addClass('open');
			$('.js-doctor-text').addClass('open-dialog_doctor');

			if ($('.js-district').hasClass('open')){
				$('.js-district').removeClass('open');
				$('.side-section-header').removeClass('open-dialog');
			};

		});

		$('.dialog-close').on('click', function (){
			$('.js-doctors').removeClass('open');
			$('.js-doctor-text').removeClass('open-dialog_doctor');
			$('.js-btn-open').removeClass('btn-opacity');
		});




		//doctors
		$('.list-item label' , '.select-specialization').on('click', function (){
			var $this = $(this),
				$parent_ = $('.' + $this.parents('#dialog-window').data('block')),
				$text = $parent_.find('.side-section_item'),
				$parent = $this.parents('.list-item'),
				$parentChoose = $this.parents('.select-specialization');

			$($text).html('');
			$parentChoose.find('.list-item').removeClass('selected');
			$('.list-item input').removeAttr('checked');
			$parent.addClass('selected');
			$this.clone().appendTo($text);
			$('<a href="#" class="item-close"></a>').appendTo('.side-section_item label');
			$('.side-section_item label').addClass('js-close-item');
			$('a.js-btn-text').text('Измените специальность');

			if 	($parent.hasClass('selected')){
				dialogWindow.removeClass('open');
				$('.side-section-header').removeClass('open-dialog');
				$('.js-doctors').removeClass('open');
				$('.js-doctor-text').removeClass('open-dialog_doctor');
				$('.js-btn-open').removeClass('btn-opacity');
			};
		});

		$('.section-doctors').on('click', '.js-close-item', function (){
			$('a.js-btn-text').text('Выберете специальность');
		});

		//delete label
		$('body').on('click', '.js-close-item', function(){
			var $block = $('#dialog-window'),
				data = $(this).data("name"),
				$item = $block.find($('[data-name=\''+ data +'\']')),
				$itemParent = $item.parents('.list-item');

			$(this).remove();
			$itemParent.removeClass('selected').find('.remove-item').remove();
			dialogWindow.find('.list-item').children().removeClass('js-district-remove');
			removeItem();
		});


		//usluga_vibor
		$('.list-item label' , '.select-diagnostic').on('click', function() {
			var $this = $(this),
				$parent = $this.parents('.list-item');

			$parent.addClass('selected');

			if ($parent.hasClass('selected')){
				$parent.append('<div class="remove-item"/>');
			}
		});

		$('body').on('click', '.remove-item', function() {
			var $this = $(this),
				$thisParent = $this.closest($('.list-item'));

			$thisParent.removeClass('selected').find('.remove-item').remove();
		});

		$('[data-clear-select]').on('click', function() {
			var $this = $('.remove-item', dialogWindow),
				$itemParent = $this.parents('.list-item__diagnost'),
				$Parent = $itemParent.parents('.list-item');

			$this.remove();
			$('.list-item').removeClass('selected');
		});


		$('.js-btn-copy' ).on('click', function() {
			var list = $('.list-item.selected label', '.select-diagnostic'),
				$parent = $('.' + $(this).parents('.window-diagnostic').data('block')),
				text = $('.side-section_item'),
				textJsp = $parent.find('.side-section_item .jspPane');

			if (text.hasClass('is-height')) {
				textJsp.html('');
				$('<a href="#" class="item-close"></a>').appendTo(list.clone().appendTo(textJsp));
				$('#dialog-window').removeClass('open');
				$('.side-section-header').removeClass('open-dialog');
			}

			else {
				text.html('');
				text.removeClass('is-height');
				$('<a href="#" class="item-close"></a>').appendTo(list.clone().appendTo('.side-section_item'));
				$('#dialog-window').removeClass('open');
				$('.side-section-header').removeClass('open-dialog');
			}

			if (text.height() >= 150) {
				text.addClass('is-height');
			}

			if (text.hasClass('is-height')) {
				textJsp.html('');
				$('<a href="#" class="item-close"></a>').appendTo(list.clone().appendTo(textJsp));
				setTimeout(function(){
					var settings = {
						autoReinitialise: true
					};
					var pane = text
					pane.jScrollPane(settings);
					var contentPane = pane.data('jsp').getContentPane();
				}, 10);
			}

			$('.side-section_item label').addClass('js-close-item');
			$('a.js-btn-text1').text('Измените услугу');

		});


		//district
		$('.list-item label' , '.js-district').on('click', function() {
			var $this = $(this),
				$parent = $this.parents('.list-item');

			$parent.addClass('selected');

			if ($parent.hasClass('selected')){
				$parent.append('<div class="remove-item"/>');
			}
		});


		//disrticts select
		$('dt.list-item').on('click', function(){
			var this_ = $(this),
				parents = this_.parents('.select-parents'),
				list_ = parents.find('.list-item'),
				item = $('.list-item').closest('.select-parents');

			this_.find('label').addClass('is-main-disrtict');
			parents.find('.district-list').find('.list-item label').addClass('js-district-remove');

			list_.addClass('selected');
			list_.append('<div class="remove-item"/>');
		});

		$('body').on('click', 'dt.list-item.selected', function() {
			removeItem()
		});

		function removeItem() {
			$('.select-parents').each(function(){
				var this_ = $(this),
					district = this_.find('.is-main-disrtict'),
					parent = district.parents('.list-item'),
					listItem = parent.next('dd').find('.list-item');

				if (!parent.hasClass('selected')){
					listItem.removeClass('selected').find('.remove-item').remove();
				}

			});
		};

		//copy disrtict
		$('.js-btn-copy__dictrict' ).on('click', function() {
			var list = $('.list-item.selected label', '.js-district'),
				$parent_ = $('.' + list.parents('.js-district').data('block')),
				text = $parent_.find('.side-section_item'),
				parent = list.parents('.list-item'),
				textJsp = $parent_.find('.side-section_item .jspPane'),
				dtList = $('dt.list-item');

			if (text.hasClass('is-height')) {
				textJsp.html('');
				$('<a href="#" class="item-close"></a>').appendTo(list.clone().appendTo(textJsp));
				$('#dialog-window').removeClass('open');
				$('.side-section-header').removeClass('open-dialog');
			}

			else {
				text.html('');
				text.removeClass('is-height');
				$('<a href="#" class="item-close"></a>').appendTo(list.clone().appendTo(text));
				$('#dialog-window').removeClass('open');
				$('.side-section-header').removeClass('open-dialog');
			}

			if (text.height() >= 150) {
				text.addClass('is-height');
			}

			if (text.hasClass('is-height')) {
				textJsp.html('');
				$('<a href="#" class="item-close"></a>').appendTo(list.clone().appendTo(textJsp));
				setTimeout(function(){
					var settings = {
						autoReinitialise: true
					};
					var pane = text
					pane.jScrollPane(settings);
					var contentPane = pane.data('jsp').getContentPane();
				}, 10);
			}



			$('.side-section_item label').addClass('js-close-item');
			$('a.js-btn-text__disrtict').text('Измените район');

			if ($('.is-main-disrtict').length){
			  text.find('.js-district-remove').remove();
			}

		});

		$('.js-btn-clear').on('click',  function() {
			var thisis = $('.list-item', '.select-district' ),
				itemParent = thisis.parents('.select-district');

			thisis.removeClass('selected').find('.remove-item').remove();
			dialogWindow.find('.list-item').children().removeClass('js-district-remove');
		});
	});

	// close dialow window mobile
	$('.js-close-window').on('click', function(e) {
		e.preventDefault();
		var self = $(this),
			modal = self.closest('.modal').data('bs.modal');
		modal['closeDialog'] = true;
		modal.hide();
		modal.$element.on('hidden.bs.modal', function() {
			self.closest('#close-dialog').remove();
		});
	});


	
	//scroll radio
	$('#request-dialog').on('show.bs.modal', function (e) {
		setTimeout(function(){
			var settings = {
						autoReinitialise: true
					};
					var pane = $('.section-form__inner').jScrollPane()
					pane.jScrollPane(settings);
					var contentPane = pane.data('jsp').getContentPane();
				}, 10);
	});



}(jQuery, document));