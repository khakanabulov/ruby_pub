# frozen_string_literal: true

class CreateRknfsrar < ActiveRecord::Migration[7.0]
  def change
    create_table :rknfsrar do |t|
      t.string :name                      # Полное_и_сокращенное_наименование_организации_сельскохозяйственного_товаропроизводителя_с_указанием_ее_ОПФ
      t.string :inn                       # ИНН_организации_сельскохозяйственного_товаропроизводителя_
      t.string :kpp                       # КПП_организации_сельскохозяйственного_товаропроизводителя_
      t.string :address_1                 # Адрес__место_нахождения___организации_сельскохозяйственного_товаропроизводителя_
      t.string :email                     # Адрес_электронной_почты_организации_сельскохозяйственного_товаропроизводителя_
      t.string :address_2                 # Место_нахождения__адрес__обособленного_подразделения_организации__осуществляющего_лицензируемый_вид_деятельности
      t.string :kpp_2                     # КПП_обособленного_подразделения_организации__осуществляющего_лицензируемый_вид_деятельности
      t.string :region_code               # Код_субъекта_Российской_Федерации_по_месту_нахождения_организации
      t.string :region_code_2             # Код_субъекта_РФ_по_месту_нахождения_обособленного_подразделения_организации__осуществляющего_лицензируемый_вид_деятельности
      t.string :kind                      # Вид_лицензируемой_деятельности_организации
      t.string :license_num               # Номер_ранее_выданной_лицензии
      t.string :license_from              # Дата_выдачи_лицензии
      t.string :license_to                # Дата_окончания_действия_лицензии
      t.string :reestr_num                # Номер_лицензии__соответствующий_номеру_записи_в_реестре
      t.string :license_info              # Сведения_о_действии_лицензии
      t.string :license_info_updated_date # Дата_изменения_сведений_о_действии_лицензии
      t.string :license_info_basis        # Основание_изменения_сведений_о_действии_лицензии
      t.string :license_info_history      # История_изменений_сведений_о_действии_лицензии
      t.string :doc_num                   # Номер_бланка
      t.string :license_organ             # Орган_выдавший_лицензию
      t.string :coords                    # Координаты
      t.string :service_date              # Дата__время_и_место_выезного_обслуживания
      t.string :service_info              # Уточненные_сведения_о_выездном_обслуживании
      t.string :product_type              # Виды_продукции
      t.string :change_date               # Дата_внесения_изменений_в_сведения_о_лицензии_по_судебным_актам_и_актам_других_органов
    end
  end
end