module TorchRnn
  def self.preprocess(input_txt: "#{ShitpostBot::CONFIG.torch_rnn_location}/data/tiny-shakespeare.txt",
                      output_h5: "#{ShitpostBot::CONFIG.torch_rnn_location}/data/tiny-shakespeare.h5",
                      output_json: "#{ShitpostBot::CONFIG.torch_rnn_location}/data/tiny-shakespeare.json",
                      val_frac: 0.1,
                      test_frac: 0.1,
                      quiet: false,
                      encoding: 'utf-8')
    input_txt = File.expand_path(input_txt)
    output_h5 = output_h5.rpartition('/')
    output_h5 = File.expand_path(output_h5[0]) + '/' + output_h5[2]
    output_json = output_json.rpartition('/')
    output_json = File.expand_path(output_json[0]) + '/' + output_json[2]
    args = ['python2.7', 'scripts/preprocess.py',
               '--input_txt', "#{input_txt}",
               '--output_h5', "#{output_h5}",
               '--output_json', "#{output_json}",
               '--val_frac', "#{val_frac}",
               '--test_frac', "#{test_frac}",
               '--encoding', "#{encoding}"]
    args << '--quiet' if quiet
    args << {:chdir => ShitpostBot::CONFIG.torch_rnn_location}
    Util.syscall(*args) 
  end
  def self.train(input_h5: "#{ShitpostBot::CONFIG.torch_rnn_location}/data/tiny-shakespeare.h5",
                 input_json: "#{ShitpostBot::CONFIG.torch_rnn_location}/data/tiny-shakespeare.json",
                 batch_size: 50,
                 seq_length: 50,
                 init_from: nil,
                 reset_iterations: 1,
                 model_type: 'lstm',
                 wordvec_size: 64,
                 rnn_size: 128,
                 num_layers: 2,
                 dropout: 0,
                 batchnorm: 0,
                 max_epochs: 50,
                 learning_rate: 0.002,
                 grad_clip: 5,
                 lr_decay_every: 5,
                 lr_decay_factor: 0.5,
                 print_every: 1,
                 checkpoint_every: 1000,
                 checkpoint_name: "#{ShitpostBot::CONFIG.torch_rnn_location}/cv/checkpoint",
                 speed_benchmark: 0,
                 memory_benchmark: 0,
                 gpu: 0,
                 gpu_backend: 'cuda')
    input_h5 = File.expand_path(input_h5)
    input_json = File.expand_path(input_json)
    checkpoint_name = checkpoint_name.rpartition('/')
    checkpoint_name = File.expand_path(checkpoint_name[0]) + '/' + checkpoint_name[2]
    args = ['th', 'train.lua',
                '-input_h5', "#{input_h5}",
                '-input_json', "#{input_json}",
                '-batch_size', "#{batch_size}",
                '-seq_length', "#{seq_length}",
                '-reset_iterations', "#{reset_iterations}",
                '-model_type', "#{model_type}",
                '-wordvec_size', "#{wordvec_size}",
                '-rnn_size', "#{rnn_size}",
                '-num_layers', "#{num_layers}",
                '-dropout', "#{dropout}",
                '-batchnorm',"#{batchnorm}",
                '-max_epochs', "#{max_epochs}",
                '-learning_rate', "#{learning_rate}",
                '-grad_clip', "#{grad_clip}",
                '-lr_decay_every', "#{lr_decay_every}",
                '-lr_decay_factor', "#{lr_decay_factor}",
                '-print_every', "#{print_every}",
                '-checkpoint_every', "#{checkpoint_every}",
                '-checkpoint_name', "#{checkpoint_name}",
                '-speed_benchmark', "#{speed_benchmark}",
                '-memory_benchmark', "#{memory_benchmark}",
                '-gpu', "#{gpu}",
                '-gpu_backend', "#{gpu_backend}"]
    args += ['-init_from', "#{init_from}"] unless init_from.nil? || init_from.empty?
    args << {:chdir => ShitpostBot::CONFIG.torch_rnn_location}
    Util.syscall(*args)
  end
  def self.sample(checkpoint: "#{ShitpostBot::CONFIG.torch_rnn_location}/cv/checkpoint_4000.t7",
                  length: 2000,
                  start_text: '',
                  sample: 1,
                  temperature: 1,
                  gpu: 0,
                  gpu_backend: 'cuda',
                  verbose: 0,
                  stop_token: '')
    checkpoint = File.expand_path(checkpoint)
    args = ['th', 'sample.lua',
                '-checkpoint', "#{checkpoint}",
                '-sample', "#{sample}",
                '-temperature', "#{temperature}",
                '-gpu', "#{gpu}",
                '-gpu_backend', "#{gpu_backend}",
                '-verbose', "#{verbose}",
                '-stop_token', "#{stop_token}"]
    args += ['-start_text', "#{start_text.chomp}"] unless start_text.nil? || start_text.chomp.empty?
    args << {:chdir => ShitpostBot::CONFIG.torch_rnn_location}
    Util.syscall(*args)
  end
end
