import { application } from "controllers/application"
import DismissController from "controllers/dismiss_controller"
import FormController from "controllers/form_controller"
import ReplyController from "controllers/reply_controller"

application.register("dismiss", DismissController)
application.register("form", FormController)
application.register("reply", ReplyController)
