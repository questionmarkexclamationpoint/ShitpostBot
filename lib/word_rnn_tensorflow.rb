module WordRnnTensorflow
  def self.train(data_dir: "#{ShitpostBot::CONFIG.word_rnn_tensorflow_location}/data/tinyshakespeare",
                 log_dir: "#{ShitpostBot::CONFIG.word_rnn_tensorflow_location}/logs",
                 save_dir: "#{ShitpostBot::CONFIG.word_rnn_tensorflow_location}/save",
                 rnn_size: 256,
                 num_layers: 2,
                 model: 'lstm',
                 batch_size: 50,
                 seq_length: 25,
                 num_epochs: 50,
                 save_every: 1000,
                 grad_clip: 5,
                 learning_rate: 0.002,
                 decay_rate: 0.97,
                 gpu_mem: 0.66,
                 init_from: nil)
    data_dir = File.expand_path(data_dir)
    save_dir = File.expand_path(save_dir)
    log_dir = File.expand_path(log_dir)
    args = [
             'python2.7', 'train.py',
             '--data_dir', "#{data_dir}",
             '--log_dir', "#{log_dir}",
             '--rnn_size', "#{rnn_size}",
             '--num_layers', "#{num_layers}",
             '--model', "#{model}",
             '--batch_size', "#{batch_size}",
             '--seq_length', "#{seq_length}",
             '--num_epochs', "#{num_epochs}",
             '--save_every', "#{save_every}",
             '--decay_rate', "#{decay_rate}",
             '--gpu_mem', "#{gpu_mem}"
           ]
    args += ['--init_from', "#{init_from}"] unless init_from.nil?
    args << {:chdir => ShitpostBot::CONFIG.word_rnn_tensorflow_location}
    Util.syscall(*args)
  end
  def self.sample(save_dir: "#{ShitpostBot::CONFIG.word_rnn_tensorflow_location}/save",
                  n: 200,
                  prime: ' ',
                  pick: 1,
                  width: 4,
                  sample: 1)
    save_dir = File.expand_path(save_dir)
    args = [
             'python2.7', 'sample.py',
             '--save_dir', "#{save_dir}",
             '-n', "#{n}",
             '--prime', "#{prime}",
             '--pick', "#{pick}",
             '--width', "#{width}",
             '--sample', "#{sample}"
           ]
    args << {:chdir => ShitpostBot::CONFIG.word_rnn_tensorflow_location}
    Util.syscall(*args)
  end
end
