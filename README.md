# Test
Стартовый проект для тестового задания в команду Рейтингов и Отзывов ВК.\



Memory Leaks:

- `ReviewsViewModel` хранит в `state.items` массив элементов, включая объекты `ReviewItem`
- Каждый `ReviewItem` содержит замыкание `onTapShowMore`, которое ссылается на `ReviewsViewModel`
- Это создает цикл сильных ссылок: `ReviewsViewModel` → `ReviewItem` → замыкание → `ReviewsViewModel`

Solution:

В методе MakeReviewItem() вместо передачи замыкания showMoreReview напрямую, используем  [weak self]:


// ReviewsViewModel.swift

func makeReviewItem(_ review: Review) -> ReviewItem {
     ...
      let item = ReviewItem(
          reviewText: reviewText,
          created: created,
          onTapShowMore: {[weak self] id in
              self?.showMoreReview(with: id)
          },
      ...
  }
  

- Для многопоточности использовал GCD 
