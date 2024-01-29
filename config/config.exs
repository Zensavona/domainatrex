import Config

if config_env() == :test do
  config :domainatrex, custom_suffixes: ["localhost"]
end
