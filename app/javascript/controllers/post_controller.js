import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"
const { StreamActions } = Turbo

export default class extends Controller {
  connect() {
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
  const piImgArea = document.getElementById('pi_img_area');

  if (uploader.files.length > 1) {
    alert('添付できるのは1枚までです');
    postImageDelete();
    return;
  } else if (uploader.files.length == 0) {
    postImageDelete();
    return;
  }

  // 画像エリアをクリア
  piImgArea.innerHTML = '';

  const files = Array.from(uploader.files);
  const promises = files.map((file, index) => {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => resolve({ image: reader.result, index });
      reader.onerror = reject;
    });
  });

  Promise.all(promises).then(results => {
    results.forEach(({ image, index }) => {
      // <div>要素を作成
      const div = document.createElement('div');
      div.className = `p-1 pi_${index + 1}_${uploader.files.length}`;

      // <img>要素を作成
      const img = document.createElement('img');
      img.src = image;
      img.className = 'pi_img rounded-3 object-fit-cover';

      // <img>要素を<div>要素に追加
      div.appendChild(img);

      // <div>要素をpi_img_areaに追加
      piImgArea.appendChild(div);
    });

    document.getElementById('postImageDeleteButton').disabled = false;
    document.getElementById('postImageDeleteButton').style.display = 'block';
  }).catch(error => {
    console.error('Error reading files:', error);
  });
};

window.postImageDelete = function() {
  const uploader = document.querySelector('.uploader');
  const piImgArea = document.getElementById('pi_img_area');

  // アップローダーの値をクリア
  uploader.value = '';

  // 画像エリアをクリア
  piImgArea.innerHTML = '';

  // デフォルト画像を追加
  const img = document.createElement('img');
  img.src = '/assets/card-image.svg';
  img.className = 'bi-card-image pi_img object-fit-contain';
  piImgArea.appendChild(img);

  // 削除ボタンを無効化し非表示にする
  const deleteButton = document.getElementById('postImageDeleteButton');
  deleteButton.disabled = true;
  deleteButton.style.display = 'none';
};

window.showPostImage = function(image) {
  document.querySelector('#post_image').setAttribute('src', image.src);
};

StreamActions.open_modal = function(){
  $('#commonModal').modal('show');
}

StreamActions.close_modal = function(){
  $('#commonModal').empty();
  $('#commonModal').modal('hide');
}
