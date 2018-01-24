%include('header_init.tpl', heading='Assess utility functions - Qualitative attributes')
<h3 id="attribute_name"></h3>

<div id="select">
	<table class="table">
		<thead>
			<tr>
				<th>Attribute</th>
				<th>Method</th>
				<th>Number of assessed points</th>
				<th>Assess another point</th>
				<th>Calculate utility function</th>
				<th>Reset assessements</th>
			</tr>
		</thead>
		<tbody id="table_attributes">
		</tbody>
	</table>
</div>

<div id="trees"></div>

<div id="charts">
	<h2>Select the regression function you want to use</h2>
</div>

<div id="main_graph" class="col-lg-5"></div>
<div id="functions" class="col-lg-7"></div>

%include('header_end.tpl')
%include('js.tpl')

<script>
	var tree_image = '{{ get_url("static", path="img/tree_choice.png") }}';
</script>

<!-- Tree object -->
<script src="{{ get_url('static', path='js/tree.js') }}"></script>

<script>
	$(function() {
		$('li.questions_quali').addClass("active");
		$('#attribute_name').hide()
		$('#charts').hide();
		$('#main_graph').hide();
		$('#functions').hide();

		var assess_session_QUALI = JSON.parse(localStorage.getItem("assess_session_QUALI"));
		var settings=assess_session_QUALI.settings;
		
		// function isInList(item, test_list) { // only works when item can be found in the first position of a table in test_list
			// for (var ii=0, leng = test_list.length; ii<leng; ii++) {
				// if(item==test_list[ii][0]){return true};
			// };
			// return false;			
		// };
		
		
		// We fill the table
		for (var i = 0; i < assess_session_QUALI.attributes.length; i++) {
			var attribute = assess_session_QUALI.attributes[i];
			
			if (!assess_session_QUALI.attributes[i].checked) //if this attribute is not activated
				continue; //we skip this attribute and go to the next one
			
			var text_table = '<tr><td>' + attribute.name + '</td>'+
							'<td>' + attribute.method + '</td>'+
							'<td>' + attribute.questionnaire.number + '</td>';
							
			if (attribute.questionnaire.number !== attribute.val_med.length) {
				
				text_table += '<td><ul><li>' + attribute.val_worst + ' : 0</li>';
				
				for (var ii=0, len=attribute.val_med.length; ii<len; ii++){
					text_table += '<li>' + attribute.val_med[ii] + ' : '; 
					if(attribute.questionnaire.points[attribute.val_med[ii]]){
						text_table += attribute.questionnaire.points[attribute.val_med[ii]];
					} else {
						text_table += '<button type="button" class="btn btn-default btn-xs answer_quest" id="q_' + attribute.name + '_' + attribute.val_med[ii] + '_' + ii + '">Assess</button>' + '</li>';
					};
				}; 
				
				text_table += '<li>' + attribute.val_best + ' : 1</li></ul></td>';
				
			} 
			else {
				text_table += '<td>All points have already been assessed</td>';
			}

			if (attribute.questionnaire.number === attribute.val_med.length) {
				text_table += '<td><button type="button" class="btn btn-default btn-xs calc_util" id="u_' + assess_session_QUALI.attributes[i].name + '">Utility function</button></td>';
			} else {
				text_table += '<td>Please assess all the medium values</td>';
			}
			
			text_table += '<td><button type="button" id="deleteK' + i + '" class="btn btn-default btn-xs">Reset</button></td>';

			$('#table_attributes').append(text_table);

			(function(_i) {
					$('#deleteK' + _i).click(function() {
							if (confirm("Are you sure ?") == false) {
									return
							};
							assess_session_QUALI.attributes[_i].questionnaire = {
									'number': 0,
									'points': {},
									'utility': {}
							};
							// backup local
							localStorage.setItem("assess_session_QUALI", JSON.stringify(assess_session_QUALI));
							//refresh the page
							window.location.reload();
					});
			})(i);
		}


		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////// CLICK ON THE ANSWER BUTTON ////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		$('.answer_quest').click(function() {
			// we store the name of the attribute
			var name_val = $(this).attr('id').split('_');//slice(2);
			alert(name_val);
			
			// we delete the select div
			$('#select').hide();
			$('#attribute_name').show().html(name.toUpperCase());


			// which index is it ? / which attribute is it ?
			var indice;
			for (var j = 0; j < assess_session_QUALI.attributes.length; j++) {
				if (assess_session_QUALI.attributes[j].name == name) {
					indice = j;
				}
			}

			var id_val_med = name.slice(
				val_worst = assess_session_QUALI.attributes[indice].val_worst,
				val_med = assess_session_QUALI.attributes[indice].val_med,
				val_best = assess_session_QUALI.attributes[indice].val_best,
				method = assess_session_QUALI.attributes[indice].method;

			function random_proba(proba1, proba2) {
				var coin = Math.round(Math.random());
				if (coin == 1) {
					return proba1;
				} else {
					return proba2;
				}
			}

			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////// PE METHOD ////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			if (method == 'PE') {
				(function() {
					// VARIABLES
					var probability = 0.75,
						min_interval = 0,
						max_interval = 1;

					// INTERFACE
					var arbre_pe = new Arbre('pe', '#trees', settings.display, "PE");
					

					// The certain gain is the clicked mad_value
					var gain_certain = ;
					
					arbre_pe.questions_val_mean = gain_certain;
					
					// SETUP ARBRE GAUCHE
					arbre_pe.questions_proba_haut = probability;
					
					arbre_pe.questions_val_max = (mode=="normal"? val_max : val_min) + ' ' + unit;
					arbre_pe.questions_val_min = (mode=="normal"? val_min : val_max) + ' ' + unit;
					
					arbre_pe.display();
					arbre_pe.update();

					$('#trees').append('</div><div class=choice style="text-align: center;"><p>Which option do you prefer?</p><button type="button" class="btn btn-default" id="gain">A</button><button type="button" class="btn btn-default" id="lottery">B</button></div>');

					// FUNCTIONS
					function sync_values() {
						arbre_pe.questions_proba_haut = probability;
						arbre_pe.update();
					}

					function treat_answer(data) {
						min_interval = data.interval[0];
						max_interval = data.interval[1];
						probability = parseFloat(data.proba).toFixed(2);

						if (max_interval - min_interval <= 0.05) {
							sync_values();
							ask_final_value(Math.round((max_interval + min_interval) * 100 / 2) / 100);
						} else {
							sync_values();
						}
					}

					function ask_final_value(val) {
						// we delete the choice div
						$('.choice').hide();
						$('.container-fluid').append(
							'<div id= "final_value" style="text-align: center;"><br /><br /><p>We are almost done. Please enter the probability that makes you indifferent between the two situations above. Your previous choices indicate that it should be between ' + min_interval + ' and ' + max_interval + ' but you are not constrained to that range <br /> ' + min_interval +
							'\
						 <= <input type="text" class="form-control" id="final_proba" placeholder="Probability" value="' + val + '" style="width: 100px; display: inline-block"> <= ' + max_interval +
							'</p><button type="button" class="btn btn-default final_validation">Validate</button></div>'
						);


						// when the user validate
						$('.final_validation').click(function() {
							var final_proba = parseFloat($('#final_proba').val());

							if (final_proba <= 1 && final_proba >= 0) {
								// we save it
								assess_session_QUALI.attributes[indice].questionnaire.points[gain_certain]=final_proba;
								assess_session_QUALI.attributes[indice].questionnaire.number += 1;
								// backup local
								localStorage.setItem("assess_session_QUALI", JSON.stringify(assess_session_QUALI));
								// we reload the page
								window.location.reload();
							}
						});
					}

					sync_values();

					// HANDLE USERS ACTIONS
					$('#gain').click(function() {
						$.post('ajax', '{"type":"question", "method": "PE", "proba": ' + String(probability) + ', "min_interval": ' + min_interval + ', "max_interval": ' + max_interval + ' ,"choice": "0", "mode": "' + 'normal' + '"}', function(data) {
							treat_answer(data);
						});
					});

					$('#lottery').click(function() {
						$.post('ajax', '{"type":"question","method": "PE", "proba": ' + String(probability) + ', "min_interval": ' + min_interval + ', "max_interval": ' + max_interval + ' ,"choice": "1" , "mode": "' + 'normal' + '"}', function(data) {
							treat_answer(data);
						});
					});
				})()
			}
		});



		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////// CLICK ON THE UTILITY BUTTON ////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		$('.calc_util').click(function() {
			// we store the name of the attribute
			var name = $(this).attr('id').slice(2);
			// we hide the slect div
			$('#select').hide();

			// which index is it ?
			var indice;
			for (var j = 0; j < assess_session_QUALI.attributes.length; j++) {
				if (assess_session_QUALI.attributes[j].name == name) {
					indice = j;
				}
			}

			var val_worst = assess_session_QUALI.attributes[indice].val_worst;
			var val_best = assess_session_QUALI.attributes[indice].val_best;
			var mode = assess_session_QUALI.attributes[indice].mode;
			var points = assess_session_QUALI.attributes[indice].questionnaire.points.slice(); //////////////////////////////////////

			points[val_worst] = 0;
			points[val_best] = 1;
			
			var json_2_send = {
				"type": "calc_util_multi" /////////////////////////
			};
			json_2_send["points"] = points;




			function reduce_signe(nombre, dpl=true, signe=true) {

				if (nombre >= 0 && signe==true) {
					if (dpl==false) {
						if (nombre > 999) {
							return ("+" + nombre.toExponential(settings.decimals_equations)).replace("e+", "\\times10^{")+"}";
						}
						else if (nombre < 0.01) {
							return ("+" + nombre.toExponential(settings.decimals_equations)).replace("e-", "\\times10^{-")+"}";
						}
						else {
							return "+" + nombre.toPrecision(settings.decimals_equations);
						}
					}
					else {
						return "+" + nombre.toPrecision(settings.decimals_dpl);
					}
				} else {
					if (dpl==false) {
						if (Math.abs(nombre) > 999) {
							return String(nombre.toExponential(settings.decimals_equations)).replace("e+","\\times10^{")+"}";
						}
						else if (Math.abs(nombre) < 0.01) {
							return String(nombre.toExponential(settings.decimals_equations)).replace("e-", "\\times10^{-")+"}";
						}
						else {
							return nombre.toPrecision(settings.decimals_equations);
						}
					}
					else {
						return nombre.toPrecision(settings.decimals_dpl);
					}
				}
			};

			function addTextForm(div_function, copie, render, key, excel) {

				if (settings.language=="french") {
					excel=excel.replace(/\./gi,",");
				}

				var copy_button_dpl = $('<button class="btn functions_text_form" id="btn_dpl_' + key + '" data-clipboard-text="' + copie + '" title="Click to copy me.">Copy to clipboard (DPL format)</button>');
				var copy_button_excel = $('<button class="btn functions_text_form" id="btn_excel_' + key + '" data-clipboard-text="' + excel + '" title="Click to copy me.">Copy to clipboard (Excel format)</button>');
				var copy_button_latex = $('<button class="btn functions_text_form" id="btn_latex_' + key + '" data-clipboard-text="' + render + '" title="Click to copy me.">Copy to clipboard (LaTeX format)</button>');

				if (settings.language=="french") {
					render=render.replace(/\./gi,",");
				}

				var ajax_render = {
					"type": "latex_render",
					"formula": render
				};

				$.post('ajax', JSON.stringify(ajax_render), function (data) {
					div_function.append("<img src='data:image/png;base64,"+ data +"' alt='"+key+"' />");
					div_function.append("<br /><br />");
					div_function.append(copy_button_dpl);
					div_function.append("<br /><br />");
					div_function.append(copy_button_excel);
					div_function.append("<br /><br />");
					div_function.append(copy_button_latex);
				});

				$('#functions').append(div_function);

				var client = new Clipboard("#btn_dpl_" + key);
				client.on("success", function(event) {
					copy_button_dpl.text("Done !");
					setTimeout(function() {
						copy_button_dpl.text("Copy to clipboard (DPL format)");
					}, 2000);
				});

				var client = new Clipboard("#btn_excel_" + key);
				client.on("success", function(event) {
					copy_button_excel.text("Done !");
					setTimeout(function() {
						copy_button_excel.text("Copy to clipboard (Excel format)");
					}, 2000);
				});

				var client = new Clipboard("#btn_latex_" + key);
				client.on("success", function(event) {
					copy_button_latex.text("Done !");
					setTimeout(function() {
						copy_button_latex.text("Copy to clipboard LaTeX format)");
					}, 2000);
				});
			}

			function addFunctions(i, data) {
				for (var key in data[i]) {

					if (key == 'exp') {
						var div_function = $('<div id="' + key + '" class="functions_graph" style="overflow-x: auto;"><h3 style="color:#401539">Exponential</h3><br />Coefficient of determination: ' + Math.round(data[i][key]['r2'] * 100) / 100 + '<br /><br/></div>');
						var copie = reduce_signe(data[i][key]['a']) + "*exp(" + reduce_signe(-data[i][key]['b']) + "x)" + reduce_signe(data[i][key]['c']);
						var render = reduce_signe(data[i][key]['a'],false, false) + 'e^{' + reduce_signe(-data[i][key]['b'],false) + 'x}' + reduce_signe(data[i][key]['c'],false);
						var excel = reduce_signe(data[i][key]['a']) + "*EXP(" + reduce_signe(-data[i][key]['b']) + "*x)" + reduce_signe(data[i][key]['c']);
						addTextForm(div_function, copie, render, key, excel);
					} else if (key == 'log') {
						var div_function = $('<div id="' + key + '" class="functions_graph" style="overflow-x: auto;"><h3 style="color:#D9585A">Logarithmic</h3><br />Coefficient of determination: ' + Math.round(data[i][key]['r2'] * 100) / 100 + '<br /><br/></div>');
						var copie = reduce_signe(data[i][key]['a']) + "*log(" + reduce_signe(data[i][key]['b']) + "x" + reduce_signe(data[i][key]['c']) + ")" + reduce_signe(data[i][key]['d']);
						var render = reduce_signe(data[i][key]['a'], false, false) + "\\log(" + reduce_signe(data[i][key]['b'], false, false) + "x" + reduce_signe(data[i][key]['c'],false) + ")" + reduce_signe(data[i][key]['d'],false);
						var excel = reduce_signe(data[i][key]['a']) + "*LN(" + reduce_signe(data[i][key]['b']) + "x" + reduce_signe(data[i][key]['c']) + ")" + reduce_signe(data[i][key]['d']);
						addTextForm(div_function, copie, render, key, excel);
					} else if (key == 'pow') {
						var div_function = $('<div id="' + key + '" class="functions_graph" style="overflow-x: auto;"><h3 style="color:#6DA63C">Power</h3><br />Coefficient of determination: ' + Math.round(data[i][key]['r2'] * 100) / 100 + '<br /><br/></div>');
						var copie = reduce_signe(data[i][key]['a']) + "*(pow(x," + (1 - data[i][key]['b']) + ")-1)/(" + reduce_signe(1 - data[i][key]['b']) + ")" + reduce_signe(data[i][key]['c']);
						var render = reduce_signe(data[i][key]['a'], false, false) + "\\frac{x^{" + reduce_signe(1 - data[i][key]['b'], false) + "}-1}{" + reduce_signe(1 - data[i][key]['b'], false) + "}" + reduce_signe(data[i][key]['c'], false);
						var excel = reduce_signe(data[i][key]['a']) + "*(x^" + (1 - data[i][key]['b']) + "-1)/(" + reduce_signe(1 - data[i][key]['b']) + ")" + reduce_signe(data[i][key]['c']);
						addTextForm(div_function, copie, render, key, excel);
					} else if (key == 'quad') {
						var div_function = $('<div id="' + key + '" class="functions_graph" style="overflow-x: auto;"><h3 style="color:#458C8C">Quadratic</h3><br />Coefficient of determination: ' + Math.round(data[i][key]['r2'] * 100) / 100 + '<br /><br/></div>');
						var copie = reduce_signe(data[i][key]['c']) + "*x" + reduce_signe(-data[i][key]['b']) + "*pow(x,2)" + reduce_signe(data[i][key]['a']);
						var render = reduce_signe(data[i][key]['c'], false, false) + "x" + reduce_signe(-data[i][key]['b'], false) + "x^{2}" + reduce_signe(data[i][key]['a'], false);
						var excel = reduce_signe(data[i][key]['c']) + "*x" + reduce_signe(-data[i][key]['b']) + "*x^2" + reduce_signe(data[i][key]['a']);
						addTextForm(div_function, copie, render, key, excel);
					} else if (key == 'lin') {
						var div_function = $('<div id="' + key + '" class="functions_graph" style="overflow-x: auto;"><h3 style="color:#D9B504">Linear</h3><br />Coefficient of determination: ' + Math.round(data[i][key]['r2'] * 100) / 100 + '<br /><br/></div>');
						var copie = reduce_signe(data[i][key]['a']) + "*x" + reduce_signe(data[i][key]['b']);
						var render = reduce_signe(data[i][key]['a'], false, false) + "x" + reduce_signe(data[i][key]['b'], false);
						var excel = reduce_signe(data[i][key]['a']) + "*x" + reduce_signe(data[i][key]['b']);
						addTextForm(div_function, copie, render, key, excel);
					} else if (key=='expo-power') {
						var div_function = $('<div id="' + key + '" class="functions_graph" style="overflow-x: auto;"><h3 style="color:#26C4EC">Expo-Power</h3><br />Coefficient of determination: ' + Math.round(data[i][key]['r2'] * 100) / 100 + '<br /><br/></div>');
						var copie = reduce_signe(data[i][key]['a']) + "+exp(-(" + reduce_signe(data[i][key]['b']) + ")*pow(x," + reduce_signe(data[i][key]['c']) + "))" ;
						var render = reduce_signe(data[i][key]['a'], false, false) + "+exp(" + reduce_signe(-data[i][key]['b'], false, false) + "*x^{" + reduce_signe(data[i][key]['c'], false, false) + "})" ;
						var excel = reduce_signe(data[i][key]['a']) + "+EXP(-(" + reduce_signe(data[i][key]['b']) + ")*x^" + reduce_signe(data[i][key]['c']) + ")" ;
						addTextForm(div_function, copie, render, key, excel);
					}
				}
			}

			function addGraph(i, data, min, max) {
				$.post('ajax', JSON.stringify({
					"type": "svg",
					"data": data[i],
					"min": min,
					"max": max,
					"liste_cord": data[i]['coord'],
					"width": 6
				}), function(data2) {
					$('#main_graph').append(data2);
				});
			}

			function availableRegressions(data) {
				var text_reg = '';
				for (var key in data) {
					if (typeof(data[key]['r2']) !== 'undefined') {
						text_reg += key + ': ' + Math.round(data[key]['r2'] * 100) / 100 + ', ';
					}
				}
				return text_reg;
			}


			$.post('ajax', JSON.stringify(json_2_send), function(data) {
				$('#charts').show();
				$('#charts').append('<table id="curves_choice" class="table"><thead><tr><th></th><th>Points used</th><th>Available regressions: r2</th></tr></thead></table>');
				for (var i = 0; i < data['data'].length; i++) {
					regressions_text = availableRegressions(data['data'][i]);
					$('#curves_choice').append('<tr><td><input type="radio" class="radio_choice" name="select" value=' + i + '></td><td>' + data['data'][i]['points'] + '</td><td>' + regressions_text + '</td></tr>');
				}
				$('.radio_choice').on('click', function() {
					$('#main_graph').show().empty();
					$('#functions').show().empty();
					addGraph(Number(this.value), data['data'], val_min, val_max);
					addFunctions(Number(this.value), data['data']);
				});
			});

		});
	});
</script>

<!-- Library to copy into clipboard -->
<script src="{{ get_url('static', path='js/clipboard.min.js') }}"></script>
</body>

</html>
