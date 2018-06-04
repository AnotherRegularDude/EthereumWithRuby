class ApplicationForm
  include Virtus.model
  include ActiveModel::Model

  def self.define_model(name)
    model_class = name.to_s.classify.constantize
    eval_code = <<-CODE.strip_heredoc
      attr_writer :model

      def model
        @model ||= #{model_class}.new
      end
    CODE

    class_eval eval_code, __FILE__, __LINE__
  end

  def save
    return false unless valid?

    persist!
  end

  delegate :persisted?, to: :model
end
