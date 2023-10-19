console.log("aquiiiiiiii");
import { Application } from "@hotwired/stimulus";
import NestedForm from "stimulus-rails-nested-form";
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers";

const application = Application.start();
application.register("nested-form", NestedForm);

const context = require.context("../controllers", true, /\.js$/);
application.load(definitionsFromContext(context));
