import { Router } from 'express'
import { middleware as query } from 'querymen'
import { middleware as body } from 'bodymen'
import { token } from '../../services/passport'
import { getScorers, getMe, getScorer, inviteScorer, update } from './controller'
import { schema } from './model'

const router = new Router()
const { email, fullName } = schema.tree

/**
 * @api {get} /users/scorers Retrieve org's scorers
 * @apiName GetScorers
 * @apiGroup User
 * @apiPermission admin
 * @apiUse listParams
 * @apiSuccess {Object[]} users List of users.
 * @apiError {Object} 400 Some parameters may contain invalid values.
 */
router.get('/scorers',
  token({ required: true, roles: ['admin'] }),
  query(),
  getScorers
)

/**
 * @api {get} /users/me Retrieve current user
 * @apiName RetrieveCurrentUser
 * @apiGroup User
 * @apiPermission user
 * @apiSuccess {Object} user User's data.
 */
router.get('/me',
  token({ required: true }),
  getMe
)

/**
 * @api {get} /users/:id Retrieve user
 * @apiName RetrieveUser
 * @apiGroup User
 * @apiPermission admin
 * @apiSuccess {Object} user User's data.
 * @apiError 404 User not found.
 */
router.get('/scorers/:id',
  token({ required: true, roles: ['admin'] }),
  getScorer
)

/**
 * @api {post} /users/scorers/invite Invite scorer
 * @apiName InviteScorer
 * @apiGroup User
 * @apiParam {String} email Scorer's email.
 * @apiSuccess (Sucess 201) {Object} user User's data.
 * @apiError {Object} 400 Some parameters may contain invalid values.
 */
router.post('/scorers/invite',
  token({ required: true, roles: ['admin'] }),
  body({ email }),
  inviteScorer
)

/**
 * @api {put} /users/:id Update myself
 * @apiName UpdateMe
 * @apiGroup User
 * @apiPermission user
 * @apiParam {String} access_token User access_token.
 * @apiSuccess {Object} user User's data.
 * @apiError {Object} 400 Some parameters may contain invalid values.
 * @apiError 404 User not found.
 */
router.put('/me',
  token({ required: true }),
  body({ fullName }),
  update
)

export default router
