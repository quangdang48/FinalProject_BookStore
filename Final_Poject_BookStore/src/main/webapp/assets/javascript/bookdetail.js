function increaseQuantity() {
    let quantity = document.getElementById("quantity");
    quantity.value = parseInt(quantity.value) + 1;
}
function decreaseQuantity() {
    let quantity = document.getElementById("quantity");
    if (parseInt(quantity.value) > 1)
        quantity.value = parseInt(quantity.value) - 1;
}

// hiển thị thông báo thêm vào giỏ hàng
function showNotification(){
    const alertBox = document.querySelector('.alert');
     // Hiển thị thông báo
    alertBox.classList.remove('d-none');
    alertBox.classList.add('fade');

    // Ẩn thông báo sau 3 giây
    setTimeout(() => {
        alertBox.classList.remove('fade');
        alertBox.classList.add('d-none');
    }, 3000); // Đóng sau 3 giây
}

// gửi dữ liệu cho add cart
function sendDataToAddCart(event) {
    const bookId = document.getElementById("bookId").value; // Dữ liệu cần gửi
    const quantity = document.getElementById("quantity").value;
//                alert(quantity);
    if (!bookId || !quantity) {
        alert("Vui lòng điền đủ thông tin.");
        return; // Dừng hàm nếu giá trị trống
    }
    // URLSearchParams() dùng để tạo đối tượng
    const data = new URLSearchParams();
    data.append('bookId', bookId);
    data.append('quantity', quantity);
    const buttonId = event.target.id; // Lấy ID của nút
    if (buttonId === "muaNgay"){
        data.append('action', "muaNgay");
    }
    else{
        data.append('action', "themVaoGio");
    }
    document.getElementById('loading-screen').style.display = 'flex';
    
    fetch('/addcart', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: data.toString() // chuyển chuỗi URLSearchParams thành chuỗi URL-encoded
      })
      .then(response => response.json())
      .then(result => {
        if(result.errorMessage !== "null"){
            // Xử lý hiện lỗi
            alert(result.errorMessage);
            document.getElementById('loading-screen').style.display = 'none';
//                        document.getElementById("errorMessage").innerText = result.message;
        }
        else{
            if(buttonId === "themVaoGio"){
                document.getElementById('loading-screen').style.display = 'none';
                showNotification();
            }
        }
        if (result.redirect) {
            // Chuyển hướng
//                        alert(result.redirect);
            window.location.href = result.redirect;
        }
        
      })
      .catch(error => console.error('Error:', error));
    
}

// Handle user rating stars
let userRating = 0;
function setUserRating(rating) {
    userRating = rating;
    const stars = document.querySelectorAll('.user-rating-star');
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.add('text-warning');
            star.classList.remove('text-muted');
        } else {
            star.classList.add('text-muted');
            star.classList.remove('text-warning');
        }
    });

    console.log(userRating);
}

function showReviewSuccessToast() {
    const alertBox = document.getElementById('review-success-toast');
    alertBox.classList.remove('d-none');
    alertBox.classList.add('fade');
    setTimeout(() => {
        alertBox.classList.remove('fade');
        alertBox.classList.add('d-none');
    }, 3000);
}

function showReviewFailToast() {
    const alertBox = document.getElementById('review-fail-toast');
    alertBox.classList.remove('d-none');
    alertBox.classList.add('fade');
    setTimeout(() => {
        alertBox.classList.remove('fade');
        alertBox.classList.add('d-none');
    }, 3000);
}

function submitReview() {
    const bookId = document.getElementById("bookId").value;
    const reviewContent = document.getElementById("reviewContent").value;
    const rating = userRating;

    if (!bookId || !rating) {
        alert("Vui lòng Rating trước khi gửi đánh giá.");
        return;
    }

    const data = new URLSearchParams();
    data.append('bookID', bookId);
    data.append('reviewContent', reviewContent);
    data.append('rate', rating);

    fetch('/submitReview', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: data.toString()
    })
    .then(response => response.json())
    .then(result => {
        if (result.errorMessage) {
            showReviewFailToast();
        } else if (result.redirect) {
            window.location.href = result.redirect;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showReviewFailToast();
    });
}

// Update review
let updateUserRating = 0;

function setUpdateUserRating(rating) {
    updateUserRating = rating;
    const stars = document.querySelectorAll('.user-rating-star');
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.add('text-warning');
            star.classList.remove('text-muted');
        } else {
            star.classList.add('text-muted');
            star.classList.remove('text-warning');
        }
    });
}

function openUpdateReviewModal(reviewId, description, rating) {
    document.getElementById('updateReviewId').value = reviewId;
    document.getElementById('updateReviewContent').value = description;
    setUpdateUserRating(rating);
    const updateReviewModal = new bootstrap.Modal(document.getElementById('updateReviewModal'));
    updateReviewModal.show();
}

function submitUpdateReview() {
    const reviewId = document.getElementById('updateReviewId').value;
    const reviewContent = document.getElementById('updateReviewContent').value;
    const rating = updateUserRating;

    if (!reviewId || !rating) {
        alert("Vui lòng Rating trước khi gửi đánh giá.");
        return;
    }

    const data = new URLSearchParams();
    data.append('reviewID', reviewId);
    data.append('reviewContent', reviewContent);
    data.append('rate', rating);

    fetch('/updateReview', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: data.toString()
    })
    .then(response => response.json())
    .then(result => {
        if (result.errorMessage) {
            showReviewFailToast();
        } else if (result.redirect) {
            window.location.href = result.redirect;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showReviewFailToast();
    });
}

function deleteReview(reviewId) {
    if (!confirm("Bạn có chắc chắn muốn xóa đánh giá này?")) {
        return;
    }

    const data = new URLSearchParams();
    data.append('reviewID', reviewId);

    fetch('/deleteReview', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: data.toString()
    })
    .then(response => response.json())
    .then(result => {
        if (result.errorMessage) {
            showReviewFailToast();
        } else if (result.redirect) {
            window.location.href = result.redirect;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showReviewFailToast();
    });
}

//        window.onload = function() {
//            // Giả lập thời gian tải nội dung (nếu muốn)
//            setTimeout(() => {
//                // Ẩn màn hình loading
//                document.getElementById('loading-screen').style.display = 'none';
//                // Hiển thị nội dung chính
//                document.getElementById('container').style.display = 'block';
//            }, 0); // Không cần delay trong trường hợp tải trang hoàn tất
//        };