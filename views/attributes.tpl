%include('header_init.tpl', heading='Manage your attributes')

<h2>List of current attributes:</h2>
<table class="table">
    <thead>
        <tr>
            <th style='width:50px;'>State</th>
			<th>Type</th>
            <th>Attribute name</th>
            <th>Unit</th>
            <th>Values</th>
            <th>Method</th>
            <th>Mode</th>
            <th>Edit</th>
            <th><button type="button" class="btn btn-danger del_simu"><img src='/static/img/delete.ico' style='width:16px;'/></button></th>
        </tr>
    </thead>
    <tbody id="table_attributes">
    </tbody>
</table>

<br />
<br />

<div id="add_attribute" style="width:50%;margin-left:25%;margin-bottom:25px;">
    <h2> Add a new attribute: </h2>
	
	<div id="button_type" style="text-align:center;">
		<button type="button" class="btn btn-default btn-lg" id="button_Quantitative">Quantitative</button>
		<button type="button" class="btn btn-default btn-lg" id="button_Qualitative">Qualitative</button>
	</div>
	
    <!------------ FORM FOR A QUANTITATIVE ATTRIBUTE ------------>
	<div id="form_quanti">
		<div class="form-group">
			<label for="att_name_quanti">Name:</label>
			<input type="text" class="form-control" id="att_name_quanti" placeholder="Name">
		</div>

		<div class="form-group">
			<label for="att_unit_quanti">Unit:</label>
			<input type="text" class="form-control" id="att_unit_quanti" placeholder="Unit">
		</div>
		<div class="form-group">
			<label for="att_value_min_quanti">Min value:</label>
			<input type="text" class="form-control" id="att_value_min_quanti" placeholder="Value">
		</div>
		<div class="form-group">
			<label for="att_value_max_quanti">Max value:</label>
			<input type="text" class="form-control" id="att_value_max_quanti" placeholder="Value">
		</div>
		<div class="form-group">
			<label for="att_method_quanti">Method:</label>
			<select class="form-control" id="att_method_quanti">
			  <option value="PE">Probability Equivalence</option>
			  <option value="CE_Constant_Prob">Certainty Equivalence - Constant Probability</option>
				  <option value="CE_Variable_Prob">Certainty Equivalence - Variable Probability</option>
			  <option value="LE">Lottery Equivalence</option>
			</select>
		</div>
		<div class="checkbox">
			<label><input name="mode" type="checkbox" id="att_mode_quanti" placeholder="Mode"> The min value is preferred (decreasing utility function)</label>
		</div>

		<button type="submit" class="btn btn-success" id="submit_quanti">Submit</button>
	</div>
	
	<!------------ FORM FOR A QUALITATIVE ATTRIBUTE ------------>
	<div id="form_quali">
		<div class="form-group">
			<label for="att_name_quali">Name:</label>
			<input type="text" class="form-control" id="att_name_quali" placeholder="Name">
		</div>
		
		<h3> Please rank the values by order of preference: </h3>

		<div class="form-group">
			<label for="att_value_min_quali">Least preferred value:</label>
			<input type="text" class="form-control" id="att_value_min_quali" placeholder="Worst value">
		</div>
		
		<div class="form-group">
			<label for="att_value_med_quali">Intermediary value(s):</label>
				<input type="button" class="btn btn-default" id="add_value_med_quali" value="Add an item"/>   
				<input type="button" class="btn btn-default" id="del_value_med_quali" value="Delete last item"/>
				<ol id="list_med_values">
					<li class="col-auto"><input type="text" class="form-control col-auto" id="att_value_med_quali_1" placeholder='Intermediary Value 1'/></li>
				</ol>
		</div>
		
		<div class="form-group">
			<label for="att_value_max_quali">Most preferred value:</label>
			<input type="text" class="form-control" id="att_value_max_quali" placeholder="Best value">
		</div>
			
		<button type="submit" class="btn btn-success" id="submit_quali">Submit</button>
	</div>
	
	
</div>

%include('header_end.tpl')
%include('js.tpl')

<script>
//First we hide the attributes creation forms, and we highlight the "Manage" tab
$("#form_quanti").hide();
$("#form_quali").hide();
$('li.manage').addClass("active");

/// Function that manages the influence of the "button_type" buttons (Quantitative/Qualitative) (just the design : green/white)
function update_method_button(type){
	var list_types = ["Quantitative", "Qualitative"];
	
	for(var i=0; i<list_types.length; i++){
		if(type==list_types[i]){
			$("#button_"+list_types[i]).removeClass('btn-default');
			$("#button_"+list_types[i]).addClass('btn-success');
		} else {
			$("#button_"+list_types[i]).removeClass('btn-success');
			$("#button_"+list_types[i]).addClass('btn-default');
		}
	}
}

/// Action from Quantitative/Qualitative button
$(function() {
	///  ACTION FROM BUTTON QUANTITATIVE
	$("#button_Quantitative").click(function () {
		update_method_button("Quantitative"); //update the active type of new attribute
		$("#form_quali").fadeOut(500);
		$("#form_quanti").fadeIn(500);
	});

	///  ACTION FROM BUTTON QUALITATIVE
	$("#button_Qualitative").click(function () {
		update_method_button("Qualitative"); //update the active type of new attribute
		$("#form_quanti").fadeOut(500);
		$("#form_quali").fadeIn(500);
	});
});


/// FUNCTION FOR A QUANTITATIVE ATTRIBUTE
$(function() {
	// When you click on the RED BIN // Delete the wole session
	$('.del_simu').click(function() {
		if (confirm("You are about to delete all the attributes and their assessments.\nAre you sure ?") == false) {
			return
		};
		localStorage.removeItem("assess_session");
		window.location.reload();
	});

	var assess_session = JSON.parse(localStorage.getItem("assess_session")),
		edit_mode = false,
		edited_attribute=0;

	if (!assess_session) {
		assess_session = {
			"attributes": [],
			"k_calculus": [{
				"method": "multiplicative",
				"active": "false",
				"k": [],
				"GK": null,
				"GU": null
			}, {
				"method": "multilinear",
				"active": "false",
				"k": [],
				"GK": null,
				"GU": null
			}],
			"settings": {
				"decimals_equations": 3,
				"decimals_dpl": 8,
				"proba_ce": 0.3,
				"proba_le": 0.3,
				"language": "english",
				"display": "trees"
			}
		};
		localStorage.setItem("assess_session", JSON.stringify(assess_session));
	}

	///////////////////////////////////////////////////////////////////////
	//////////////////////         FUNCTIONS         //////////////////////
	///////////////////////////////////////////////////////////////////////
	
	// Function to know if "name" is an existing attribute of the current session
	function isAttribute(name) {
		for (var i = 0; i < assess_session.attributes.length; i++) {
			if (assess_session.attributes[i].name == name) {
				return true;
			};
		};
		return false;
	};
	
	// Function to check if there is an underscore in the typed values
	function isThereUnderscore(val_list, val_min, val_max){
		var list_len = val_list.length;
		for (var i=0; i<list_len; i++) {
			if (val_list[i].search("_")!=-1){
				return false;
			};
		};
		if (val_min.search("_")!=-1 || val_max.search("_")!=-1){
			return false;
		};
		return true;
	};

	function checked_button_clicked(element) {
		var checked = $(element).prop("checked");
		var i = $(element).val();

		//we modify the propriety
		var assess_session = JSON.parse(localStorage.getItem("assess_session"));
		assess_session.attributes[i].checked = checked;

		//we update the assess_session storage
		localStorage.setItem("assess_session", JSON.stringify(assess_session));
	}

	function sync_table() {
		$('#table_attributes').empty();
		if (assess_session) {
			for (var i = 0; i < assess_session.attributes.length; i++) {
				var attribute = assess_session.attributes[i];
				
				var text_table = "<tr>";
				text_table += '<td><input type="checkbox" id="checkbox_' + i + '" value="' + i + '" name="' + attribute.name + '" '+(attribute.checked ? "checked" : "")+'></td>'+
							  '<td>' + attribute.type + '</td>'+
							  '<td>' + attribute.name + '</td>'+
							  '<td>' + attribute.unit + '</td>'+
							  '<td>[' + attribute.val_min + ',' + attribute.val_max + ']</td>'+
							  '<td>' + attribute.method + '</td>'+
							  '<td>' + attribute.mode + '</td>'+
							  '<td><button type="button" id="edit_' + i + '" class="btn btn-default btn-xs">Edit</button></td>'+
							  '<td><button type="button" class="btn btn-default" id="deleteK'+i+'"><img src="/static/img/delete.ico" style="width:16px"/></button></td></tr>';

				$('#table_attributes').append(text_table);

				//we will define the action when we click on the check input
				$('#checkbox_' + i).click(function() {
					checked_button_clicked($(this))
				});

				(function(_i) {
					$('#deleteK' + _i).click(function() {
						if (confirm("You are about to delete the attribute "+assess_session.attributes[_i].name+".\nAre you sure ?") == false) {
							return
						};
						assess_session.attributes.splice(_i, 1);
						// backup local
						localStorage.setItem("assess_session", JSON.stringify(assess_session));
						//refresh the page
						window.location.reload();
					});
				})(i);

				(function(_i) {
					$('#edit_' + _i).click(function() {
					  edit_mode=true;
					  edited_attribute=_i;
					  var attribute_edit = assess_session.attributes[_i];
					  $('#add_attribute h2').text("Edit attribute "+attribute_edit.name);
					  $('#att_name_quanti').val(attribute_edit.name);
					  $('#att_unit_quanti').val(attribute_edit.unit);
					  $('#att_value_min_quanti').val(attribute_edit.val_min);
					  $('#att_value_max_quanti').val(attribute_edit.val_max);
					  $('#att_method_quanti option[value='+attribute_edit.method+']').prop('selected', true);
					  if (attribute_edit.mode=="Normal") {
						$('#att_mode_quanti').prop('checked', false);
					  } else {
						$('#att_mode_quanti').prop('checked', true);
					  }
					});
				})(i);
			}

		}
	}
	sync_table();

	var name = $('#att_name_quanti').val();

	$('#submit_quanti').click(function() {
		var name = $('#att_name_quanti').val(),
			unit = $('#att_unit_quanti').val(),
			val_min = parseInt($('#att_value_min_quanti').val()),
			val_max = parseInt($('#att_value_max_quanti').val());

		var method = "PE";
		if ($("select option:selected").text() == "Probability Equivalence") {
			method = "PE";
		} else if ($("select option:selected").text() == "Lottery Equivalence") {
			method = "LE";
		} else if ($("select option:selected").text() == "Certainty Equivalence - Constant Probability") {
			method = "CE_Constant_Prob";
		} else if ($("select option:selected").text() == "Certainty Equivalence - Variable Probability") {
			method = "CE_Variable_Prob";
		}

		if ($('input[name=mode]').is(':checked')) {
			var mode = "Reversed";
		} else {
			var mode = "Normal";
		}

		if (!(name || unit || val_min || val_max) || isNaN(val_min) || isNaN(val_max)) {
			alert('Please fill correctly all the fields');
		} else if (isAttribute(name) && (edit_mode == false)) {
			alert ("An attribute with the same name already exists");
		} else if (val_min > val_max) {
			alert ("Minimum value must be inferior to maximum value");
		} else if (val_min<0 || val_max<0 ) {
			alert ("Values must be positive or zero");
		} else if (isThereUnderscore([name, unit], String(val_min), String(val_max))==false) {
			alert("Please don't write an underscore ( _ ) in your values.\nBut you can put spaces");
		}
		
		else {
			if (edit_mode==false) {
				assess_session.attributes.push({
					"type": "Quantitative",
					"name": name,
					'unit': unit,
					'val_min': val_min,
					'val_med': [
						String(parseFloat(val_min)+.25*(parseFloat(val_max)-parseFloat(val_min))),
						String(parseFloat(val_min)+.50*(parseFloat(val_max)-parseFloat(val_min))), //yes, it's (val_max+val_min)/2, but it looks better ^^
						String(parseFloat(val_min)+.75*(parseFloat(val_max)-parseFloat(val_min)))
					],
					'val_max': val_max,
					'method': method,
					'mode': mode,
					'completed': 'False',
					'checked': true,
					'questionnaire': {
						'number': 0,
						'points': {},
						'utility': {}
					}
				});
			} else {
				if (confirm("Are you sure you want to edit the attribute? All assessements will be deleted") == true) {
					assess_session.attributes[edited_attribute]={
						"type": "Quantitative",
						"name": name,
						'unit': unit,
						'val_min': val_min,
						'val_med': [
							String(parseFloat(val_min)+.25*(parseFloat(val_max)-parseFloat(val_min))),
							String(parseFloat(val_min)+.50*(parseFloat(val_max)-parseFloat(val_min))), //yes, it's (val_max+val_min)/2, but it looks better ^^
							String(parseFloat(val_min)+.75*(parseFloat(val_max)-parseFloat(val_min)))
						],
						'val_max': val_max,
						'method': method,
						'mode': mode,
						'completed': 'False',
						'checked': true,
						'questionnaire': {
							'number': 0,
							'points': {},
							'utility': {}
						}
					};
				}	
				edit_mode=false;
				$('#add_attribute h2').text("Add a new attribute");
			}
			sync_table();
			localStorage.setItem("assess_session", JSON.stringify(assess_session));
			$('#att_name_quanti').val("");
			$('#att_unit_quanti').val("");
			$('#att_value_min_quanti').val("");
			$('#att_value_max_quanti').val("");
			$('#att_method_quanti option[value="PE"]').prop('selected', true);
			$('#att_mode_quanti').prop('checked', false);
		}
	});
});

/// FUNCTION FOR A QUALITATIVE ATTRIBUTE

</script>
</body>

</html>
