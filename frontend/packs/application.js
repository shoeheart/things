/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import "init";
import "components/menu/menu";
import "components/home/home";
import "components/profile/profile";
import "components/animals/animals";
import "components/animal-form/animal-form";
import "components/toys/toys";
import "components/toy/toy";
import "components/toy_types/toy_types";
import "components/toy_type/toy_type";
import Rails from "rails-ujs";
import * as ActiveStorage from "activestorage";
// import AWS from "aws-sdk";

ActiveStorage.start();
Rails.start();