require "openai"
require "json"

class AiAnswerExplainer
  def self.test_connection
    api_key = ENV['OPENAI_API_KEY']
    puts "API Key present: #{api_key.present?}"
    puts "API Key format: #{api_key&.slice(0, 10)}..." if api_key
    
    # 簡単な接続テスト
    client = OpenAI::Client.new(access_token: api_key)
    response = client.models.list
    puts "Connection successful: #{response.dig('data')&.any?}"
  rescue => e
    puts "Connection failed: #{e.message}"
  end
  MODEL = "gpt-4o-mini"

  SYSTEM_PROMPT = <<~SYS.freeze
    あなたはバスケットボール戦術の家庭教師です。
    出力は必ず以下のJSON形式（UTF-8）で返してください：
    {
      "selected_reason": "受験者の選択理由（120〜200字）",
      "per_choice": [
        {"index": 1, "correct": true, "reason": "理由（70字以内）"},
        {"index": 2, "correct": true, "reason": "理由（70字以内）"}
      ],
      "summary": "問題の要点（80〜120字）",
      "tip": "実戦アドバイス（80字以内）"
    }
    小学生にも伝わる日本語で、簡潔に、しかし具体例を入れて説明してください。
    JSON以外は一切出力しないでください。
  SYS

  USER_TEMPLATE = <<~PROMPT.freeze
    問題文: %{question}
    選択肢:
    %{choices}
    正解: %{correct_index}番
    受験者の選択: %{selected_index}番
    以下の項目について、JSON形式で回答してください：
    - selected_reason: 受験者の選択が正解/不正解である理由を戦術の原理に触れて120〜200字で説明
    - per_choice: 各選択肢の正誤と理由（70字以内）を配列で
    - summary: この問題で学ぶべき戦術のポイントを80〜120字で
    - tip: 実戦で活用できる具体的なアドバイスを80字以内で
    注意：JSON以外の文章は一切含めないでください。
  PROMPT

  def self.call(question_text:, choices_texts:, correct_index:, selected_index:)
    Rails.logger.info("[AiAnswerExplainer] Starting API call")

    # ✅ ruby-openai gem 対応のクライアント初期化
    client = OpenAI::Client.new

    choices_block = choices_texts.each_with_index.map { |t, i| "#{i + 1}. #{t}" }.join("\n")

    correct_line =
      if correct_index
        "正解: #{correct_index}番"
      else
        "正解: なし（解説のみ提示）"
      end

    prompt = format(
      USER_TEMPLATE,
      question:       question_text,
      choices:        choices_block,
      correct_index:  correct_index || "なし",
      selected_index: selected_index
    )

    started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    begin
      # ✅ ruby-openai gem対応のAPI呼び出し
      response = client.chat(
        parameters: {
          model: MODEL,
          messages: [
            { role: "system", content: SYSTEM_PROMPT },
            { role: "user", content: prompt }
          ],
          response_format: { type: "json_object" },
          temperature: 0.2
        }
      )

      elapsed_ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at) * 1000).round

      text = response.dig("choices", 0, "message", "content")
      raise "Empty response from OpenAI" if text.nil? || text.strip.empty?

      json = JSON.parse(text, symbolize_names: true)
      
      Rails.logger.info("[AiAnswerExplainer] API call successful in #{elapsed_ms}ms")
      return json, elapsed_ms, MODEL

    rescue => e
      Rails.logger.error("[AiAnswerExplainer] Error: #{e.class}: #{e.message}")
      return fallback_json(choices_texts, correct_index, "AI通信エラーが発生しました。"), 0, MODEL
    end
  end

  private

  def self.fallback_json(choices_texts, correct_index, reason)
    {
      selected_reason: reason,
      per_choice: choices_texts.each_with_index.map { |_, i|
        { index: i + 1, correct: (i + 1) == correct_index, reason: "復旧用メッセージ" }
      },
      summary: "復旧用の要約です。",
      tip: "復旧用のアドバイスです。"
    }
  end
end
