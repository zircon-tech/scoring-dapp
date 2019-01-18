import { Router } from 'express'
import { middleware as body } from 'bodymen'
import { login, signupOrganization, signupScorer } from './controller'
import { password as passwordAuth } from '../../services/passport'

import { schema as userSchema } from '../user/model'
import { schema as organizationSchema } from '../organization/model'

const router = new Router()

const { email, password, fullName } = userSchema.tree
const { organizationName } = organizationSchema.tree

/**
 * @api {post} /auth/organization/signup Create organization account
 * @apiName CreateOrganization
 * @apiGroup Organization
 * @apiParam {String} email User's email.
 * @apiParam {String{6..}} password User's password.
 * @apiParam {String} [fullName] User's name.
 * @apiParam {String} [organizationName] Org name.
 * @apiSuccess (Sucess 201) {Object} user User's data.
 * @apiError {Object} 400 Some parameters may contain invalid values.
 * @apiError 409 Email already registered.
 */
router.post('/organization/signup', body({ email, password, fullName, organizationName }), signupOrganization)

/**
 * @api {post} /auth/organization/signup Create organization account
 * @apiName CreateScorer
 * @apiGroup Scorer
 * @apiParam {String{6..}} password User's password.
 * @apiParam {String} [fullName] User's name.
 * @apiSuccess (Sucess 201) {Object} user User's data.
 * @apiError {Object} 400 Some parameters may contain invalid values.
 * @apiError 409 Email already registered.
 */
router.post('/scorer/signup', body({ fullName, password, token: { type: String, required: true } }), signupScorer)

/**
 * @api {post} /auth Authenticate
 * @apiName Authenticate
 * @apiGroup Auth
 * @apiHeader {String} Authorization Basic authorization with email and password.
 * @apiSuccess (Success 201) {String} token User `access_token` to be passed to other requests.
 * @apiSuccess (Success 201) {Object} user Current user's data.
 */
router.post('/login', passwordAuth(), login)

export default router
