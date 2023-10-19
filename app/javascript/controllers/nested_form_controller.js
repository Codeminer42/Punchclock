import NestedForm from "stimulus-rails-nested-form";

export default class extends NestedForm {
  connect() {
    super.connect();
    console.log("Do what you want here.");
  }
}
