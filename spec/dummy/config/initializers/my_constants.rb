if Rails.env.production?
  SUBURI = Authentify::AuthentifyUtility.find_config_const('SUBURI')
else
  SUBURI = ''
end
#set session timeout minutes
SESSION_TIMEOUT_MINUTES = Authentify::AuthentifyUtility.find_config_const('SESSION_TIMEOUT_MINUTES').to_i
SESSION_WIPEOUT_HOURS = Authentify::AuthentifyUtility.find_config_const('SESSION_WIPEOUT_HOURS').to_i

# twitter buttons class
BUTTONS_CLS = {'default' => Authentify::AuthentifyUtility.find_config_const('default-btn'),
               'action'  => Authentify::AuthentifyUtility.find_config_const('action-btn'),
               'info'    => Authentify::AuthentifyUtility.find_config_const('info-btn'),
               'success' => Authentify::AuthentifyUtility.find_config_const('success-btn'),
               'warning' => Authentify::AuthentifyUtility.find_config_const('warning-btn'),
               'danger'  => Authentify::AuthentifyUtility.find_config_const('danger-btn'),
               'inverse' => Authentify::AuthentifyUtility.find_config_const('inverse-btn'),
               'link'    => Authentify::AuthentifyUtility.find_config_const('link-btn')
              }


