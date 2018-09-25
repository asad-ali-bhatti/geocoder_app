require 'app_spec_helper'

RSpec.describe Server do
  let(:valid_request) { 'GET /geocode?location=Lahore HTTP/1.1'  }
  let(:invalid_request) { 'GET /BLABLA HTTP/1.1' }

  describe '#run' do
    let(:tcp_server) { TCPServer.new(3001) }

    before do
      allow(tcp_server).to receive(:accept).and_return(tcp_server, nil)
      allow(Server).to receive(:rack_app).and_return(['',{}, []])
      allow(Server).to receive(:tcp_server).and_return(tcp_server)
      allow(tcp_server).to receive(:gets).and_return('GET / HTTP/1.1')
      allow(tcp_server).to receive(:print)
    end

    it 'process incoming requests and wait for the next' do
      expect(Server).to receive(:rack_app)
      Server.run
    end
  end

  describe '#tcp_server' do
    it 'should return TCP server' do
      expect(Server.tcp_server.class).to be_eql(TCPServer)
    end
  end

  describe '#rack_app' do
    it 'should return a tiplet with response code, headers hash and body array' do
      response = Server.rack_app(valid_request)
      expect(response[0]).to be_eql('200')
      expect(response[1].class).to be_eql(Hash)
      expect(response[2].class).to be_eql(Array)
    end


    context 'when uri is not valid' do
      it 'should return response code 404' do
        response = Server.rack_app(invalid_request)
        expect(response[0]).to be_eql('404')
      end
    end

    context 'when uri is valid' do
      it 'should return response code 200' do
        response = Server.rack_app(valid_request)
        expect(response[0]).to be_eql('200')
      end
    end
  end
end
