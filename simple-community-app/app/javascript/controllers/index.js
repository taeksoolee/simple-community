import { application } from "controllers/application"
import FormController from "controllers/form_controller"
import ReplyController from "controllers/reply_controller"

application.register("form", FormController)
application.register("reply", ReplyController)
