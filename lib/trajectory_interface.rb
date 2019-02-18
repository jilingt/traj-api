require 'open3'

def predict(inputs)
    # Open3.popen3("code-name", inputs) do |stdin, stdout, stderr, wait_thr|
    #     while line = stdout.gets
    #         puts line
    #     end
    # end
    output, status = Open3.capture2("valbal-traj", stdin_data: inputs)
    return output
end
