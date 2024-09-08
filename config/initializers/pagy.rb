require 'pagy/extras/bootstrap'

Pagy::DEFAULT[:limit] = 25

require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page
