$(".txtb input").on("focus",function(){
	$(this).addClass("focus");
});

$(".txtb input").on("blur",function(){
	if($(this).val() == "")
	$(this).removeClass("focus");
});

$(function() {
	window.addEventListener('message', function(event) {
		if (event.data.action === "showOrgMenu"){
			$('#orgmenuUI').show();
			$('body').addClass("active");
		} else if (event.data.action === "showCriarOrgMenu"){
			$('#criar-convitesUI').show();
			$('body').removeClass("active");
		} else if (event.data.action === "hideMenu"){
			$('#criar-convitesUI').hide();
			$('#criarorgUI').hide();
			$('#orgmenuUI').hide();
			$('#cargosmenuUI').hide();
			$('body').removeClass("active");
		}

		if (event.data.nomeORG)
        {
			$('#nome-orgMenu').html('ORG: ' + event.data.nomeORG);
        }
        
	});
});

$('.botao-criar-org').click(function(){
	$('#criar-convitesUI').hide();
	$('#criarorgUI').show();
})
$('.botao-retornar-criarorg').click(function(){
	$('#criarorgUI').hide();
	$('#orgmenuUI').show();
})
$(".confirmar-criarorg").click(function() {
	console.log($("#nomeorg").val())
	$.post('https://org_criminosas/org_criarorg', JSON.stringify({
		nomeORG: $("#nomeorg").val()
	}));
	$('#criarorgUI').hide();
	$("#nomeorg").val('');
});
$('.botao-gerenciar-membros').click(function(){
	e.preventDefault();
	$.post('https://vrp_banco/sacar', JSON.stringify({
		amounts: $("#amounts").val()
	}));
	$('#orgmenuUI').hide();
	$('#cargosmenuUI').show();
})
$('#btn-convites').click(function(){
	$('#criar-convitesUI').hide();
})
$("#sacar1").submit(function(e) {
	e.preventDefault();
	$.post('https://vrp_banco/sacar', JSON.stringify({
		amounts: $("#amounts").val()
	}));
	$('#sacarUI').hide();
	$('#general').show();
	$("#amounts").val('');
});
document.onkeyup = function(data){
	if (data.which == 27){
		$('#criar-convitesUI').hide();
		$('#criarorgUI').hide();
		$('#orgmenuUI').hide();
		$('#cargosmenuUI').hide();
		$('body').removeClass("active");
		$.post('https://org_criminosas/NUIFocusOff', JSON.stringify({}));
	}
}

