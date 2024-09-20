import express from "express";
import { registerInstitute, loginInstitute, logoutInstitute} from "../controllers/instituteController.js";

const router = express.Router();

// Institute registration and login
router.post("/register", registerInstitute);
router.post("/login", loginInstitute);
router.get("/logout", logoutInstitute);

// // Department management (by institute)
// router.post("/department/add", isAuthenticatedInstitute, addDepartment);
// router.delete("/department/delete/:id", isAuthenticatedInstitute, deleteDepartment);

// // Resource management (by institute)
// router.get("/resources", isAuthenticatedInstitute, getAllResources);
// router.post("/resources/add", isAuthenticatedInstitute, addResource);
// router.put("/resources/update/:id", isAuthenticatedInstitute, updateResource);
// router.delete("/resources/delete/:id", isAuthenticatedInstitute, deleteResource);

// // Profile management
// router.put("/profile", isAuthenticatedInstitute, updateInstituteProfile);

export default router;
