import Foundation

public enum Strings {
    // MARK: - screens
    public enum Screen {
        public static let records = NSLocalizedString(
            "Записи",
            comment: "Заголовок экрана записей"
        )

        public static let newRecord = NSLocalizedString(
            "Новая запись",
            comment: "Заголовок экрана создания записи"
        )

        public static let editRecord = NSLocalizedString(
            "Редактировать запись",
            comment: "Заголовок экрана редактирования записи"
        )

        public static let trash = NSLocalizedString(
            "Корзина",
            comment: "Заголовок экрана корзины"
        )

        public static let analysisOptions = NSLocalizedString(
            "Настройки",
            comment: "Заголовок экрана настроек анализа"
        )
        
        public static let print = NSLocalizedString(
            "Печать",
            comment: "Заголовок экрана печати"
        )

        public static let emailSettings = Button.emailSettings

        public static let emailSettingsDescription = NSLocalizedString(
            "Введите адрес, который будет использоваться по умолчанию для отправки отчетов по e-mail.",
            comment: "Описание на экране настроек e-mail"
        )
    }



    // MARK: - buttons
    public enum Button {
        public static let cancel = NSLocalizedString(
            "Отмена",
            comment: "Кнопка отмены"
        )

        public static let ok = NSLocalizedString(
            "ОК",
            comment: "Кнопка подтверждения"
        )

        public static let answers = NSLocalizedString(
            "Ответы",
            comment: "Кнопка перехода на экран ответов"
        )

        public static let print = NSLocalizedString(
            "Печать",
            comment: "Кнопка перехода к опциям печати"
        )

        public static let email = NSLocalizedString(
            "E-mail",
            comment: "Кнопка отправки письма"
        )

        public static let emailSettings = NSLocalizedString(
            "Адрес по умолчанию",
            comment: "Кнопка настроек e-mail"
        )

        public static let delete = NSLocalizedString(
            "Удалить",
            comment: "Кнопка удаления"
        )

        public static let compare = NSLocalizedString(
            "Сравнить",
            comment: "Кнопка сравнения"
        )

        public static let filterResults = NSLocalizedString(
            "Фильтр значений",
            comment: "Опция анализа"
        )

        public static let hideNormalResults = NSLocalizedString(
            "Скрыть норму",
            comment: "Опция анализа"
        )
    }



    // MARK: - forms
    public enum Form {
        public static let personName = NSLocalizedString(
            "Название",
            comment: "Поле 'ФИО' формы редактирования записи"
        )

        public static let personNamePlaceholder =
            NSLocalizedString(
                "Пациент № 12345",
                comment: "Плейсхолдер поля 'ФИО' формы редактирования записи"
            )

        public static let gender = NSLocalizedString(
            "Пол",
            comment: "Поле 'Пол' формы редактирования записи"
        )

        public static let ageGroup = NSLocalizedString(
            "Возрастная группа",
            comment: "Поле 'Возрастная группа' формы редактирования записи"
        )

        public static let date = NSLocalizedString(
            "Дата тестирования",
            comment: "Поле 'Дата тестирования' формы редактирования записи"
        )

        public static let emailPlaceholder = NSLocalizedString(
            "email@example.com",
            comment: "Плейсхолдер для e-mail адреса"
        )
    }



    // MARK: - values
    public enum Value {
        public static let ageGroupAdult = NSLocalizedString(
            "Взрослая",
            comment: "Название возрастной группы"
        )

        public static let ageGroupTeen = NSLocalizedString(
            "Подростковая",
            comment: "Название возрастной группы"
        )

        public static let genderMale = NSLocalizedString(
            "Мужской",
            comment: "Пол"
        )

        public static let genderFemale = NSLocalizedString(
            "Женский",
            comment: "Пол"
        )

        public static let unknown = NSLocalizedString(
            "Неизвестно",
            comment: "Незивестное значение"
        )
    }



    // MARK: - analysis
    public enum Analysis {
        public static let format_N_of_M = NSLocalizedString(
            "%ld из %ld",
            comment: "N из M"
        )

        public static let yes = NSLocalizedString(
            "ДА",
            comment: "Позитивный ответ"
        )

        public static let no = NSLocalizedString(
            "НЕТ",
            comment: "Негативный ответ"
        )

        public static let normalScorePlaceholder = "-"
    }



    // MARK: - reports
    public enum Report {
        public static let answers = NSLocalizedString(
            "Ответы",
            comment: "Название отчета по ответам"
        )

        public static let overall = NSLocalizedString(
            "Анализ (все шкалы)",
            comment: "Название общего отчета по анализу"
        )

        public static let brief = NSLocalizedString(
            "Анализ (краткий)",
            comment: "Название общего отчета по анализу"
        )

        public static let email = Button.email

        public static let emailSubjectSuffix = NSLocalizedString(
            "- тест",
            comment: "Суффикс темы письма с отчетом"
        )
    }
}
