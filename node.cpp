#include <chrono>
#include <array>
#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/int32.hpp>

using namespace std::chrono_literals;

class TestPublisher : public rclcpp::Node
{
public:
  TestPublisher() : Node("cpp_test")
  {
    pub_ = create_publisher<std_msgs::msg::Int32>("/esp32/state_cmd", 10);

    // Timer principal periódico usando 500ms (2 Hz)
    timer_ = create_wall_timer(500ms, [this]() {
      // Medindo o tempo de execução do callback usando std::chrono::steady_clock
      auto start_time = std::chrono::steady_clock::now();

      std_msgs::msg::Int32 msg;
      msg.data = seq_[idx_];
      pub_->publish(msg);

      // Obtendo o timestamp atual do ROS 2
      rclcpp::Time ros_time = this->now();
      RCLCPP_INFO(get_logger(), "Enviado: %d | ROS Timestamp (s): %.3f", msg.data, ros_time.seconds());

      idx_ = (idx_ + 1) % seq_.size();

      auto end_time = std::chrono::steady_clock::now();
      auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time);
      
      // Logando a latência interna do ciclo de publicação
      RCLCPP_DEBUG(get_logger(), "Tempo de processamento do ciclo: %ld us", duration.count());
    });

    // Exemplo de Timer de Disparo Único (One-shot): executa apenas uma vez após 2 segundos
    init_timeout_timer_ = create_wall_timer(2s, [this]() {
      RCLCPP_INFO(get_logger(), "[Timeout] 2 segundos se passaram desde a inicialização do nó.");
      
      // Cancela o timer para que ele não dispare novamente
      init_timeout_timer_->cancel();
    });
  }

private:
  rclcpp::Publisher<std_msgs::msg::Int32>::SharedPtr pub_;
  rclcpp::TimerBase::SharedPtr timer_;
  rclcpp::TimerBase::SharedPtr init_timeout_timer_; // Ponteiro para o timer único
  
  const std::array<int, 5> seq_{0, 1, -1, 0, 2};
  size_t idx_ = 0;
};

int main(int argc, char ** argv)
{
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<TestPublisher>());
  rclcpp::shutdown();
  return 0;
}