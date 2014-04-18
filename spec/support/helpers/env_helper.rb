module EnvHelper
  def fake_env
    fake_env = double(:fake_env)
    allow(Figaro).to receive(:env).and_return fake_env
    fake_env
  end
end