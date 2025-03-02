/// Модель отзыва.
struct Review: Decodable {

    /// User's first name
    let first_name: String?
    /// User's last name
    let last_name: String?
    /// Rating
    let rating: Int
    /// Текст отзыва.
    let text: String
    /// Время создания отзыва.
    let created: String

}
