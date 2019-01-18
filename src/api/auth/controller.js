import { sign } from '../../services/jwt'
import { success, badRequest } from '../../services/response/'
import { Organization } from '../organization'
import User from '../user/model'

export const signupOrganization = async ({ bodymen: { body } }, res, next) => {
  try {
    let user = await User.findOne({ email: body.email })
    if (user) {
      return badRequest(res, 'Email already exists')
    }
    let organization = new Organization({
      organizationName: body.organizationName
    })

    const { email, password, fullName } = body
    user = new User({
      role: 'admin',
      email,
      password,
      fullName,
      organization
    })

    // Call web3 to register organization and user

    await organization.save()
    await user.save()

    user = await user.populate('organization').execPopulate()

    return success(res, 201)({ user: user.view() })
  } catch (err) {
    next(err)
  }
}

export const signupScorer = (req, res, next) => {
  // TODO

  // Call web3 to register scorer

  return success(res, 201)({})
}

export const login = async ({ user }, res, next) => {
  try {
    const token = await sign(user.id)
    return success(res, 201)({ token, user: user.view() })
  } catch (err) {
    next(err)
  }
}
