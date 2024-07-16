import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}

window.countValueLengthContent = function(value) {
  var count = value.length;
  var count_post = $('#countValueLength');
  var submit_button = $('#submitButton');
  count_post.text(140 - count);
  if (140 - count >= 0) {
    count_post.css("color", "black");
    if (count == 0) {
      submit_button.prop("disabled", true);
    } else {
      submit_button.prop("disabled", false);
    }
  } else {
    count_post.css("color", "red");
    submit_button.prop("disabled", true);
  }
}

window.postImageChange = function() {
  const uploader = document.querySelector('.uploader');
  const file = uploader.files[0];
  const reader = new FileReader();
  reader.readAsDataURL(file);
  reader.onload = () => {
    const image = reader.result;
    document.querySelector('.post_images').setAttribute('src', image);
    $('#postImageDeleteButton').prop('disabled', false);
    $('#postImageDeleteButton').show();
  }
}

window.postImageDelete = function() {
  if (confirm('画像を削除しますか？')) {
    $('.uploader').val(null);
    $('.post_images').attr('src', '/assets/card-image.svg');
    $('#postImageDeleteButton').prop('disabled', true);
    $('#postImageDeleteButton').hide();
  }
}
