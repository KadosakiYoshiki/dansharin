import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}

window.profileImageChange = function() {
  const uploader = document.querySelector('.uploader');
  const file = uploader.files[0];
  const reader = new FileReader();
  reader.readAsDataURL(file);
  reader.onload = () => {
    const image = reader.result;
    document.querySelector('.profile_image').setAttribute('src', image);
  }
}

window.searchUsableUsername = function(value) {
  var result = $('#searchUsableUsernameResult');
  var form_area = $('#user_username');
  var submit_button = $('#userEditSubmitButton');
  if (!value.length) {
    result.text('ユーザIDを入力してください。');
    validNGMessage(result, form_area, submit_button);
  } else if (value.length > 16) {
    result.text('ユーザIDは16文字までです。');
    validNGMessage(result, form_area, submit_button);
  } else {
    if (/^[a-zA-Z0-9_]*$/.test(value)) {
      var params = "";
      params += `username=${value}`;
      $.ajax({
        url: "/users/search",
        type: "GET",
        dataType: 'json',
        data: params
      }).done(function (data) {
        result.text(data.message);
        if (data.valid) {
          validOKMessage(result, form_area, submit_button);
        } else {
          validNGMessage(result, form_area, submit_button);
        }
      }).fail(function() {
        result.text('エラーが発生しました。');
        validNGMessage(result, form_area, submit_button);
      });
    } else {
      result.text('使用できない文字が含まれています。');
      validNGMessage(result, form_area, submit_button);
    }
  }
}

function validOKMessage(result, form_area, submit_button) {
  result.css('color', 'green');
  form_area.addClass('border-success is-valid');
  form_area.removeClass('border-danger is-invalid');
  submit_button.prop("disabled", false);
}

function validNGMessage(result, form_area, submit_button) {
  result.css('color', 'red');
  form_area.addClass('border-danger is-invalid');
  form_area.removeClass('border-success is-valid');
  submit_button.prop("disabled", true);
}
