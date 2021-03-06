class ScriptsController < ApplicationController
  def create
    render :text => 'No scriptfile given', :status => 400 unless params[:scriptfile]
    render :text => 'No timingfile given', :status => 400 unless params[:timingfile]

    slug = Digest::SHA1.hexdigest([params[:scriptfile], params[:timingfile]].inspect)[0..20]

    Script.create(:scriptfile => params[:scriptfile],
                  :timingfile => params[:timingfile],
                  :cols => (params[:cols] || 80).to_i,
                  :lines => params[:lines],
                  :slug => slug,
                  :ip_address => env['HTTP_X_REAL_IP'] || env['REMOTE_ADDR'])

    render :text => "#{base_address}/#{CGI.escape(slug)}"
  end

  def base_address
    if request.base_url == "https://showterm.herokuapp.com"
      "http://showterm.io"
    else
      request.base_url
    end
  end

  def view
    @script = Script.find_by_slug(params[:slug])
  end

  def index
  end
end
