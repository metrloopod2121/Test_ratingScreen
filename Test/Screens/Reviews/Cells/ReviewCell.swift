import UIKit

/// Конфигурация ячейки. Содержит данные для отображения в ячейке.
struct ReviewCellConfig {

    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: ReviewCellConfig.self)

    /// Идентификатор конфигурации. Можно использовать для поиска конфигурации в массиве.
    let id = UUID()
    /// Текст отзыва.
    let reviewText: NSAttributedString
    /// Максимальное отображаемое количество строк текста. По умолчанию 3.
    var maxLines = 3
    /// Время создания отзыва.
    let created: NSAttributedString
    /// Замыкание, вызываемое при нажатии на кнопку "Показать полностью...".
    let onTapShowMore: (UUID) -> Void
    
    /// Avatar for user
    let userAvatarImage: UIImage
    /// User's first name
    let firstName: String
    /// User's last name
    let lastName: String
    /// User Rating
    let userRatingImage: UIImage
    
    /// Объект, хранящий посчитанные фреймы для ячейки отзыва.
    fileprivate let layout = ReviewCellLayout()

}

// MARK: - TableCellConfig

extension ReviewCellConfig: TableCellConfig {

    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? ReviewCell else { return }
        cell.reviewTextLabel.attributedText = reviewText
        cell.reviewTextLabel.numberOfLines = maxLines
        cell.createdLabel.attributedText = created
        cell.userAvatarImage.image = userAvatarImage
        cell.userNameLabel.text = "\(firstName) \(lastName)"
        cell.userRatingImage.image = userRatingImage
        cell.config = self
    }

    /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat {
        layout.height(config: self, maxWidth: size.width)
    }

}

// MARK: - Private

private extension ReviewCellConfig {
    /// Текст кнопки "Показать полностью..."
    static let showMoreText = "Показать полностью..."
        .attributed(font: .showMore, color: .showMore)

}





// MARK: - Cell

final class ReviewCell: UITableViewCell {

    fileprivate var config: Config?

    fileprivate let reviewTextLabel = UILabel()
    fileprivate let createdLabel = UILabel()
    fileprivate let showMoreButton = UIButton()
    fileprivate let userAvatarImage = UIImageView()
    fileprivate let userNameLabel = UILabel()
    fileprivate let userRatingImage = UIImageView()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = config?.layout else { return }
        userAvatarImage.frame = layout.userAvatarFrame
        userRatingImage.frame = layout.userRatingImageFrame
        reviewTextLabel.frame = layout.reviewTextLabelFrame
        createdLabel.frame = layout.createdLabelFrame
        showMoreButton.frame = layout.showMoreButtonFrame
        userNameLabel.frame = layout.userNameLabelFrame
    }

}

// MARK: - Private

private extension ReviewCell {

    func setupCell() {
        setupUserAvatarImage()
        setupUserRatingImage()
        setupUserNameLabel()
        setupReviewTextLabel()
        setupCreatedLabel()
        setupShowMoreButton()
    }
    
    func setupUserRatingImage() {
        contentView.addSubview(userRatingImage)
    }
    
    func setupUserNameLabel() {
        contentView.addSubview(userNameLabel)
        userNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        userNameLabel.numberOfLines = 0
        userNameLabel.lineBreakMode = .byWordWrapping
    }
    
    func setupUserAvatarImage() {
        contentView.addSubview(userAvatarImage)
        userAvatarImage.contentMode = .scaleAspectFill
        userAvatarImage.layer.cornerRadius = ReviewCellLayout.avatarCornerRadius
        userAvatarImage.clipsToBounds = true
    }

    func setupReviewTextLabel() {
        contentView.addSubview(reviewTextLabel)
        reviewTextLabel.lineBreakMode = .byWordWrapping
        reviewTextLabel.font = .systemFont(ofSize: 16)
    }

    func setupCreatedLabel() {
        contentView.addSubview(createdLabel)
    }

    func setupShowMoreButton() {
        contentView.addSubview(showMoreButton)
        showMoreButton.contentVerticalAlignment = .fill
        showMoreButton.setAttributedTitle(Config.showMoreText, for: .normal)
    }

}

// MARK: - Layout

/// Класс, в котором происходит расчёт фреймов для сабвью ячейки отзыва.
/// После расчётов возвращается актуальная высота ячейки.
private final class ReviewCellLayout {

    // MARK: - Размеры

    fileprivate static let avatarSize = CGSize(width: 36.0, height: 36.0)
    fileprivate static let avatarCornerRadius = 18.0
    fileprivate static let photoCornerRadius = 8.0

    private static let photoSize = CGSize(width: 55.0, height: 66.0)
    private static let showMoreButtonSize = Config.showMoreText.size()

    // MARK: - Фреймы

    private(set) var reviewTextLabelFrame = CGRect.zero
    private(set) var showMoreButtonFrame = CGRect.zero
    private(set) var createdLabelFrame = CGRect.zero
    private(set) var userAvatarFrame = CGRect.zero
    private(set) var userNameLabelFrame = CGRect.zero
    private(set) var userRatingImageFrame = CGRect.zero

    // MARK: - Отступы

    /// Отступы от краёв ячейки до её содержимого.
    private let insets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 9.0, right: 12.0)

    /// Горизонтальный отступ от аватара до имени пользователя.
    private let avatarToUsernameSpacing = 10.0
    /// Вертикальный отступ от имени пользователя до вью рейтинга.
    private let usernameToRatingSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до текста (если нет фото).
    private let ratingToTextSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до фото.
    private let ratingToPhotosSpacing = 10.0
    /// Горизонтальные отступы между фото.
    private let photosSpacing = 8.0
    /// Вертикальный отступ от фото (если они есть) до текста отзыва.
    private let photosToTextSpacing = 10.0
    /// Вертикальный отступ от текста отзыва до времени создания отзыва или кнопки "Показать полностью..." (если она есть).
    private let reviewTextToCreatedSpacing = 6.0
    /// Вертикальный отступ от кнопки "Показать полностью..." до времени создания отзыва.
    private let showMoreToCreatedSpacing = 6.0

    // MARK: - Расчёт фреймов и высоты ячейки

    /// Возвращает высоту ячейку с данной конфигурацией `config` и ограничением по ширине `maxWidth`.
    func height(config: Config, maxWidth: CGFloat) -> CGFloat {
        let width = maxWidth - insets.left - insets.right

        var maxY = insets.top
        var showShowMoreButton = false
        
        // Avatar Image
        let avatarX = insets.left
//        let avatarY = insets.top
        userAvatarFrame = CGRect(
            origin: CGPoint(x: avatarX, y: maxY),
            size: Self.avatarSize
        )
        
        // Username Label
        let userNameSize = "\(config.firstName) \(config.lastName)".boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: UIFont.systemFont(ofSize: 16)],
            context: nil
        ).size

        userNameLabelFrame = CGRect(
            origin: CGPoint(x: avatarX + userAvatarFrame.width + avatarToUsernameSpacing, y: maxY),
            size: CGSize(width: width, height: userNameSize.height)
        )
        
        maxY = userNameLabelFrame.maxY + usernameToRatingSpacing
        
        // user rating
        let userRatingImageX = insets.left + userAvatarFrame.width + avatarToUsernameSpacing
        userRatingImageFrame = CGRect(
            origin: CGPoint(x: userRatingImageX, y: maxY),
            size: config.userRatingImage.size
        )
        
        maxY = userRatingImageFrame.maxY + ratingToTextSpacing

        // Review Text
        if !config.reviewText.isEmpty() {
            // Высота текста с текущим ограничением по количеству строк.
            let currentTextHeight = (config.reviewText.font()?.lineHeight ?? .zero) * CGFloat(config.maxLines)
            // Максимально возможная высота текста, если бы ограничения не было.
            let actualTextHeight = config.reviewText.boundingRect(width: width).size.height
            // Показываем кнопку "Показать полностью...", если максимально возможная высота текста больше текущей.
            showShowMoreButton = config.maxLines != .zero && actualTextHeight > currentTextHeight
            
            let textWidth = width - userAvatarFrame.width - avatarToUsernameSpacing
            reviewTextLabelFrame = CGRect(
                origin: CGPoint(x: insets.left + userAvatarFrame.width + avatarToUsernameSpacing, y: maxY),
                size: config.reviewText.boundingRect(width: textWidth, height: currentTextHeight).size
            )
            maxY = reviewTextLabelFrame.maxY + reviewTextToCreatedSpacing
        } else { maxY = userRatingImageFrame.maxY + ratingToTextSpacing }
        
        if showShowMoreButton {
            showMoreButtonFrame = CGRect(
                origin: CGPoint(x: insets.left + userAvatarFrame.width + avatarToUsernameSpacing, y: maxY),
                size: Self.showMoreButtonSize
            )
            maxY = showMoreButtonFrame.maxY + showMoreToCreatedSpacing
        } else {
            showMoreButtonFrame = .zero
        }

        createdLabelFrame = CGRect(
            origin: CGPoint(x: insets.left + userAvatarFrame.width + avatarToUsernameSpacing, y: maxY),
            size: config.created.boundingRect(width: width).size
        )

        return createdLabelFrame.maxY + insets.bottom
    }

}

// MARK: - Typealias

fileprivate typealias Config = ReviewCellConfig
fileprivate typealias Layout = ReviewCellLayout
