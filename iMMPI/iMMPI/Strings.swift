import Foundation

enum Strings {
    // MARK: - screens
    enum Screen {
        static let records = NSLocalizedString("Записи", comment: "Заголовок экрана записей")
        static let newRecord = NSLocalizedString("Новая запись", comment: "Заголовок экрана создания записи")
        static let editRecord = NSLocalizedString("Редактировать запись",
                                                  comment: "Заголовок экрана редактирования записи")

        static let trash = NSLocalizedString("Корзина", comment: "Заголовок экрана корзины")
        static let analysisOptions = NSLocalizedString("Настройки", comment: "Заголовок экрана настроек анализа")
        static let print = NSLocalizedString("Печать", comment: "Заголовок экрана печати")

        static let emailSettings = Button.emailSettings
        static let emailSettingsDescription = NSLocalizedString("Введите адрес, который будет использоваться по умолчанию для отправки отчетов по e-mail.", comment: "Описание на экране настроек e-mail")
    }



    // MARK: - buttons
    enum Button {
        static let cancel = NSLocalizedString("Отмена", comment: "Кнопка отмены")
        static let ok = NSLocalizedString("ОК", comment: "Кнопка подтверждения")

        static let answers = NSLocalizedString("Ответы", comment: "Кнопка перехода на экран ответов")
        static let print = NSLocalizedString("Печать", comment: "Кнопка перехода к опциям печати")
        static let email = NSLocalizedString("E-mail", comment: "Кнопка отправки письма")
        static let emailSettings = NSLocalizedString("Адрес по умолчанию", comment: "Кнопка настроек e-mail")
        static let delete = NSLocalizedString("Удалить", comment: "Кнопка удаления")

        static let filterResults = NSLocalizedString("Фильтр значений", comment: "Опция анализа")
        static let hideNormalResults = NSLocalizedString("Скрыть норму", comment: "Опция анализа")
    }



    // MARK: - forms
    enum Form {
        static let personName = NSLocalizedString("ФИО", comment: "Поле 'ФИО' формы редактирования записи")

        static let personNamePlaceholder =
            NSLocalizedString("Иванов Иван Иванович",
                              comment: "Плейсхолдер поля 'ФИО' формы редактирования записи")

        static let gender = NSLocalizedString("Пол", comment: "Поле 'Пол' формы редактирования записи")

        static let ageGroup =
            NSLocalizedString("Возрастная группа", comment: "Поле 'Возрастная группа' формы редактирования записи")

        static let date =
            NSLocalizedString("Дата тестирования", comment: "Поле 'Дата тестирования' формы редактирования записи")

        static let emailPlaceholder = NSLocalizedString("email@example.com", comment: "Плейсхолдер для e-mail адреса")
    }



    // MARK: - values
    enum Value {
        static let ageGroupAdult = NSLocalizedString("Взрослая", comment: "Название возрастной группы")
        static let ageGroupTeen = NSLocalizedString("Подростковая", comment: "Название возрастной группы")

        static let genderMale = NSLocalizedString("Мужской", comment: "Пол")
        static let genderFemale = NSLocalizedString("Женский", comment: "Пол")

        static let unknown = NSLocalizedString("Неизвестно", comment: "Незивестное значение")
    }



    // MARK: - analysis
    enum Analysis {
        static let format_N_of_M = NSLocalizedString("%ld из %ld", comment: "N из M")

        static let yes = NSLocalizedString("ДА", comment: "Позитивный ответ")
        static let no = NSLocalizedString("НЕТ", comment: "Негативный ответ")

        static let normalScorePlaceholder = "-"
    }



    // MARK: - reports
    enum Report {
        static let answers = NSLocalizedString("Ответы", comment: "Название отчета по ответам")
        static let overall = NSLocalizedString("Анализ (все шкалы)", comment: "Название общего отчета по анализу")
        static let email = Button.email

        static let emailSubjectSuffix = NSLocalizedString("- тест", comment: "Суффикс темы письма с отчетом")
    }
}
