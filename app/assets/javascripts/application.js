//= require jquery
//= require jquery_ujs
//= require_self

$(window).load(function() {
  fadeout('#notice');
  fadeout('#alert');
});

function fadeout(element) {
	if($(element) != undefined)
	{
  		$(element).fadeOut("slow");
	}
}

function show_element(element) {
	if ($(element).is(':visible')) { 
		element = '#files_and_folders'; 
	}

	elements = ['#files_and_folders','#permissions','#clipboard'];
	elements.splice(elements.indexOf(element), 1);

	jQuery.each(elements, function(index, value) {
		if ($(value) != undefined && $(value).is(':visible')) { 
			$(value).slideUp("slow"); 
		}
	});

	$(element).slideDown("slow");
	if ($('#show_' + element + '_link') != undefined) { 
		$('#show_' + element + '_link').addClass('highlight');
	}

	jQuery.each(elements, function(index, value) {
		if ($('#show_' + value + '_link') != undefined) { 
			$('#show_' + value + '_link').addClass('folder_menu'); 
		}
	});
}

function update_counter(element, counter) {
	$(counter).innerHTML = element.value.length;
	$(counter).style.color = element.value.length > 256 ? '#F00' : '#000';
}
