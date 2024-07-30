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
  var pi_img_area = document.getElementById('pi_img_area');
  if (uploader.files.length <= 4) {
    $('#pi_img_area').empty();
    const fileList = uploader.files;
    const files = Array.from(fileList);
    files.map((file, i) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => {
        const image = reader.result;
    
        var div = document.createElement('div');
        div.setAttribute('class', `p-1 pi_${i+1}_${uploader.files.length}`);
    
        // <img>要素を作成
        var img = document.createElement('img');
        img.setAttribute('src', image);
        img.setAttribute('class', 'pi_img rounded-3 object-fit-cover');
    
        // <img>要素を<div>要素に追加
        div.appendChild(img);
    
        // divをpi_img_areaに追加
        pi_img_area.appendChild(div);
      }
    });
    $('#postImageDeleteButton').prop('disabled', false);
    $('#postImageDeleteButton').show();
  } else {
    alert('添付できるのは4枚までです');
    postImageDelete();
  }
}

window.postImageDelete = function() {
  $('.uploader').val(null);
  $('#pi_img_area').empty();
  var img = document.createElement('img');
  img.setAttribute('src', '/assets/card-image.svg');
  img.setAttribute('class', "bi-card-image pi_img object-fit-contain");
  pi_img_area.appendChild(img);
  $('#postImageDeleteButton').prop('disabled', true);
  $('#postImageDeleteButton').hide();
}

window.showPostImage = function(image) {
  document.querySelector('#post_image').setAttribute('src', image.src);
}
